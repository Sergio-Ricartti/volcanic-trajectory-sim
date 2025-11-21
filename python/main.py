import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
import pandas as pd
from matplotlib_scalebar.scalebar import ScaleBar

def mapa_euler():
    datos_e = pd.read_csv('C:/Users/ricar/Documents/ExpoIngenieria2025/python/puntos_de_impacto.csv')

    puntos_x_e = datos_e['x'].tolist()
    puntos_y_e = datos_e['y'].tolist()

    x = np.linspace(-400, 400, 100)
    y = np.linspace(-400, 400, 100)
    X, Y = np.meshgrid(x, y)

    densidad = np.zeros((100,100))
    sigma = 10
    for i in range(len(puntos_x_e)):
        distancia = np.sqrt((X - puntos_x_e[i])**2 + (Y - puntos_y_e[i])**2)
        densidad += np.exp(-(distancia**2) / (2 * sigma**2))

    fig1, ax1 = plt.subplots()

    n = 256
    colors = np.ones((n, 3)) 
    colors[:, 1] = np.linspace(1, 0, n)
    colors[:, 2] = np.linspace(1, 0, n)
    cmap = ListedColormap(colors)

    plt.contourf(X, Y, densidad, levels=20, cmap=cmap)
    plt.colorbar(label='Nivel de Riesgo')

    plt.xlabel('Distancia Escala 1:100')
    plt.ylabel('Distancia Escala 1:100')
    plt.title('Mapa de Riesgo Volcánico (Euler)')
    plt.grid(True, alpha=0.3)

    scalebar = ScaleBar(100, 'm', length_fraction=0.25, location='lower left', color='black')
    ax1.add_artist(scalebar)

    plt.savefig('mapa_riesgo.png',dpi=300)
    plt.show(block=False)
    plt.pause(5)
def mapa_rk4():
    datos_rk4 = pd.read_csv('C:/Users/ricar/Documents/ExpoIngenieria2025/python/puntos_de_impacto_rk4.csv')

    puntos_x_rk4 = datos_rk4['x'].tolist()
    puntos_y_rk4 = datos_rk4['y'].tolist()

    x = np.linspace(-400, 400, 100)
    y = np.linspace(-400, 400, 100)
    X, Y = np.meshgrid(x, y)

    densidad = np.zeros((100,100))
    sigma = 10
    for i in range(len(puntos_x_rk4)):
        distancia = np.sqrt((X - puntos_x_rk4[i])**2 + (Y - puntos_y_rk4[i])**2)
        densidad += np.exp(-(distancia**2) / (2 * sigma**2))

    fig2, ax2 = plt.subplots()

    n = 256
    colors = np.ones((n, 3))  
    colors[:, 0] = np.linspace(1, 0, n)  
    colors[:, 1] = np.linspace(1, 0, n) 
    cmap = ListedColormap(colors)

    plt.contourf(X, Y, densidad, levels=20, cmap=cmap)
    plt.colorbar(label='Nivel de Riesgo')

    plt.xlabel('Distancia Escala 1:100')
    plt.ylabel('Distancia Escala 1:100')
    plt.title('Mapa de Riesgo Volcánico (RK4)')
    plt.grid(True, alpha=0.3)

    scalebar = ScaleBar(100, 'm', length_fraction=0.25, location='lower left', color='black')
    ax2.add_artist(scalebar)

    plt.savefig('mapa_riesgo_rk4.png',dpi=300)
    plt.show(block=False)
    plt.pause(5)
mapa_rk4()
mapa_euler()