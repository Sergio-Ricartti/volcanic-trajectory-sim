import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
import pandas as pd

datos = pd.read_csv('C:/Users/ricar/Documents/ExpoIngenieria2025/python/puntos_de_impacto.csv')

puntos_x = datos['x'].tolist()
puntos_y = datos['y'].tolist()

x = np.linspace(-400, 400, 100)
y = np.linspace(-400, 400, 100)
X, Y = np.meshgrid(x, y)

densidad = np.zeros((100,100))
sigma = 10
for i in range(len(puntos_x)):
    distancia = np.sqrt((X - puntos_x[i])**2 + (Y - puntos_y[i])**2)
    densidad += np.exp(-(distancia**2) / (2 * sigma**2))

if np.max(densidad) > 0:
    densidad = densidad / np.max(densidad)

plt.figure()

n = 256
colors = np.zeros((n, 3))
colors[:, 0] = 1
colors[:, 1] = np.linspace(1, 0, n)
colors[:, 2] = 0
cmap = ListedColormap(colors)

plt.contourf(X, Y, densidad, levels=20, cmap=cmap)
plt.colorbar(label='Nivel de Riesgo')

plt.xlabel('X (km)')
plt.ylabel('Y (km)')
plt.title('Mapa de Riesgo Volcánico')
plt.axis('equal')
plt.legend('Escala 1:100')
plt.grid(True, alpha=0.3)

plt.savefig('mapa_riesgo.png',dpi=300)
plt.show()