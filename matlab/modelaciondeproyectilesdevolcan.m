% FORMA DEL VOLCÁN
n = 100;                  % Resolución
altura_pico = 196;        
radio_base = 150;         
apertura = 1;             % Controla la forma

[X, Y] = meshgrid(linspace(-radio_base, radio_base, n));
R = sqrt(X.^2 + Y.^2);

altura_base = altura_pico * (1 - (R / radio_base).^apertura);
altura_base(R > radio_base) = 0;

crater_outer = 12;        
crater_inner = 5;         
crater_profundidad = 35;  

crater_mask_outer = R <= crater_outer;
perfil = zeros(size(R));
perfil(crater_mask_outer) = (1 - (R(crater_mask_outer) / crater_outer).^2);

altura_con_crater = altura_base;
altura_con_crater(crater_mask_outer) = altura_con_crater(crater_mask_outer) - crater_profundidad * perfil(crater_mask_outer);

crater_mask_inner = R <= crater_inner;
pozo_extra = 15;  
altura_con_crater(crater_mask_inner) = altura_con_crater(crater_mask_inner) - pozo_extra;

Z = altura_con_crater;
Z(Z < 0) = 0;

% Parámetros Iniciales
g = 9.81;                  
densidad = 0.81;           
Cd = 0.62;                 
diametro = 0.0697;         
area = pi*(diametro/2)^2;  
D = -0.5*area*densidad*Cd; 

dt = 0.01;                  
tmax = 300;                 
crater_elevation = max(Z(:));  % Altura del cráter (se usa como origen)

% Rangos para valores aleatorios
num_proyectiles = 15;
v0min = 30;              
v0max = 50;              
inclinacionmin = 30;      
inclinacionmax = 65;      
rotacionmin = 0;          
rotacionmax = 360;        
masamin = 0.13;           
masamax = 0.5;  

% Crear figura
figure;

try
    % Cargar la textura
    textura = imread('Volcan.jpg');
    textura_resized = imresize(textura, [n, n]);
    surf(X, Y, Z, textura_resized, 'FaceColor', 'texturemap', 'EdgeColor', 'none');
    material dull;
catch ME
    warning('Error al cargar textura: %s', ME.message);
    surf(X, Y, Z);
    colormap(gray);
    shading interp;
end

lighting gouraud;
camlight('headlight');
xlabel('X (km)');
ylabel('Y (km)');
zlabel('Altura (km)');
title('Simulación de Proyectiles Volcánicos con Cráter y Magma Visible');
axis([-400 400 -400 400 0 400]);
hold on;
grid on;
view(120, 55);

% Se agregan comunidades y sus posiciones
ciudades = {
    -150, -170, 0, 'San Juan Alotenango';
    180, -200, 0, 'San Pedro Yepocapa';
    -120, 210, 0, 'El Rodeo'
};

% Marcar cada ciudad en la figura 3D
for i = 1:size(ciudades, 1)
    x = ciudades{i, 1};
    y = ciudades{i, 2};
    z = ciudades{i, 3};
    nombre = ciudades{i, 4};
    
    % Etiqueta
    text(x, y, z + 20, nombre,'FontSize', 12, 'FontWeight', 'bold', 'Color', 'white');
end
% Definir aleatorios y método de euler
trayectorias = cell(num_proyectiles, 1);
max_puntos = 0;
puntos_impacto_x = [];  
puntos_impacto_y = [];  

for i = 1:num_proyectiles
    v0 = v0min + (v0max - v0min)*rand();
    theta = inclinacionmin + (inclinacionmax - inclinacionmin)*rand();
    gamma = rotacionmin + (rotacionmax - rotacionmin)*rand();
    masa = masamin + (masamax - masamin)*rand();
    
    vx = v0 * cosd(theta) * sind(gamma);
    vy = v0 * cosd(theta) * cosd(gamma);
    vz = v0 * sind(theta);
    
    x = 0; y = 0; z = crater_elevation;
    
    x_tray = x;
    y_tray = y;
    z_tray = z;
    
    t = 0;
    
    while t < tmax && z > 0
        v = sqrt(vx^2 + vy^2 + vz^2);
        
        ax = (D/masa) * v * vx;
        ay = (D/masa) * v * vy;
        az = -g - (D/masa) * v * vz;
        
        vx = vx + ax * dt;
        vy = vy + ay * dt;
        vz = vz + az * dt;
        
        x = x + vx * dt;
        y = y + vy * dt;
        z = z + vz * dt;
        t = t + dt;
        
        z_terreno = interp2(X, Y, Z, x, y, 'linear', NaN);
        if ~isnan(z_terreno) && z <= z_terreno
            z = z_terreno;
            x_tray(end+1) = x;
            y_tray(end+1) = y;
            z_tray(end+1) = z;
            break;
        end
        
        x_tray(end+1) = x;
        y_tray(end+1) = y;
        z_tray(end+1) = max(z, 0);
    end
    
    trayectorias{i}.x = x_tray;
    trayectorias{i}.y = y_tray;
    trayectorias{i}.z = z_tray;
    
    % Guardar punto de impacto para mapa de riesgo
    puntos_impacto_x(end+1) = x_tray(end);
    puntos_impacto_y(end+1) = y_tray(end);
    
    max_puntos = max(max_puntos, length(x_tray));
end
% ANIMACIÓN
lineas = gobjects(num_proyectiles, 1);
marcadores = gobjects(num_proyectiles, 1);

for i = 1:num_proyectiles
    lineas(i) = plot3(nan, nan, nan, 'LineWidth', 2, 'Color', 'r');
    marcadores(i) = plot3(nan, nan, nan, 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k');
end

velocidad_animacion = 20;

for frame = 1:velocidad_animacion:max_puntos
    for i = 1:num_proyectiles
        n_puntos = min(frame, length(trayectorias{i}.x));
        if n_puntos > 0
            set(lineas(i), 'XData', trayectorias{i}.x(1:n_puntos),'YData', trayectorias{i}.y(1:n_puntos),'ZData', trayectorias{i}.z(1:n_puntos));
            set(marcadores(i), 'XData', trayectorias{i}.x(n_puntos),'YData', trayectorias{i}.y(n_puntos), 'ZData', trayectorias{i}.z(n_puntos));
        end
    end
    drawnow;
    pause(0.01);
end

for i = 1:num_proyectiles
    set(marcadores(i), 'XData', trayectorias{i}.x(end),'YData', trayectorias{i}.y(end),'ZData', trayectorias{i}.z(end));
end

hold off;

% Mapa de Riesgo
figure('Name', 'Mapa de Riesgo Volcánico');

% Crear grid para el mapa de densidad
grid_resolution = 50;
x_grid = linspace(-400, 400, grid_resolution);
y_grid = linspace(-400, 400, grid_resolution);
[X_grid, Y_grid] = meshgrid(x_grid, y_grid);

% Calcular densidad de impactos
sigma = 30;  
densidad = zeros(size(X_grid));

for i = 1:length(puntos_impacto_x)
    % Calcular la contribución de cada impacto a todo el grid
    distancia = sqrt((X_grid - puntos_impacto_x(i)).^2 + (Y_grid - puntos_impacto_y(i)).^2);
    densidad = densidad + exp(-(distancia.^2) / (2 * sigma^2));
end

% Normalizar densidad
densidad = densidad / max(densidad(:));

% Crear el mapa de calor
contourf(X_grid, Y_grid, densidad, 20, 'LineStyle', 'none');
hold on;

% Colormap de riesgo (amarillo -> naranja -> rojo)
n_colors = 256;
cmap_riesgo = [ones(n_colors, 1), linspace(1, 0, n_colors)', zeros(n_colors, 1)];
colormap(cmap_riesgo);

% Crear colorbar y agregar etiqueta
cbar = colorbar;
ylabel(cbar, 'Nivel de Riesgo');

% Dibujar contorno del volcán
theta_volcan = linspace(0, 2*pi, 100);
x_volcan = radio_base * cos(theta_volcan);
y_volcan = radio_base * sin(theta_volcan);
plot(x_volcan, y_volcan, 'k-', 'LineWidth', 2);

% Agregar ciudades al mapa de riesgo
for i = 1:size(ciudades, 1)
    x = ciudades{i, 1};
    y = ciudades{i, 2};
    nombre = ciudades{i, 4};
    
    % Punto de la ciudad (círculo negro)
    plot(x, y, 'o', 'MarkerSize', 12, 'MarkerFaceColor', 'black');
    
    % Etiqueta con fondo blanco para mejor legibilidad
    text(x + 15, y + 15, nombre,'FontSize', 11, 'FontWeight', 'bold', 'Color', 'black');
end

% Etiquetas y título
xlabel('X (km)');
ylabel('Y (km)');
title('Mapa de Riesgo Volcánico - Densidad de Impactos');
axis equal;
grid on;
hold off;