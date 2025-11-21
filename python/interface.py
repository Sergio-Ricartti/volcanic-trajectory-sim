import tkinter as tk
from PIL import Image, ImageTk

# Lista de volcanes
volcanes = [
    'Popocatepetl',
    'Volcan de Colima',
    'El Chichon',
    'Ceboruco',
    'Tacana',
    'San Martin Tuxtla',
    'Evermann',
    'Las Tres Virgenes',
    'Chichinautzin',
    'Sanganguey',
    'Paricutin',
    'Jorullo',
    'Pico de Orizaba',
    'Xitle'
]
metodo_actual = 'euler'

def seleccionar_metodo(metodo):
    global metodo_actual
    metodo_actual = metodo
    
    seleccion = listbox.curselection()
    if seleccion:
        mostrar_mapa(None)

def mostrar_mapa(event):
    seleccion = listbox.curselection()
    if seleccion:
        indice = seleccion[0]
        volcan = volcanes[indice]

        if metodo_actual == 'euler':
            archivo = 'risk_map ' + str(indice + 1) + '.png'
        else:
            archivo = 'risk_map_rk4 ' + str(indice + 1) + '.png'
        
        img = Image.open(archivo)
        img = img.resize((600, 500))
        photo = ImageTk.PhotoImage(img)
            
        label_imagen.config(image=photo)
        label_imagen.image = photo

ventana = tk.Tk()
ventana.title('Interfaz de Usuario')
ventana.geometry('900x600')

frame_izq = tk.Frame(ventana, width=250)
frame_izq.pack(side=tk.LEFT, fill=tk.BOTH)

tk.Label(frame_izq, text='Método:', font=('Arial', 11, 'bold')).pack()

btn_euler = tk.Button(frame_izq, text='Euler', font=('Arial', 10), bg='red', fg='white', width=18, height=2, command=lambda: seleccionar_metodo('euler'))
btn_euler.pack()

btn_rk4 = tk.Button(frame_izq, text='Runge-Kutta 4', font=('Arial', 10), bg='blue', fg='white', width=18, height=2, command=lambda: seleccionar_metodo('rk4'))
btn_rk4.pack()

tk.Label(frame_izq, text='Volcanes:', font=('Arial', 11, 'bold')).pack()

listbox = tk.Listbox(frame_izq, font=('Arial', 10))
listbox.pack(fill=tk.BOTH, expand=True)

for volcan in volcanes:
    listbox.insert(tk.END, volcan)

listbox.bind('<<ListboxSelect>>', mostrar_mapa)

frame_der = tk.Frame(ventana)
frame_der.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True)

label_imagen = tk.Label(frame_der)
label_imagen.pack(fill=tk.BOTH, expand=True)

ventana.mainloop()