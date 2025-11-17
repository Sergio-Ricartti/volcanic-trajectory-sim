import tkinter as tk

def mostrar_seleccion():
    indices = listbox.curselection()  
    
    if indices:  
        indice = indices[0]  
        elemento = listbox.get(indice)  

root = tk.Tk()
root.title('Interfaz de Usuario')
root.geometry('800x600')

listbox = tk.Listbox(root, height=5)
listbox.pack()

volcanes = ['Popocatépetl', 'Colima', 'Paricutín']
for i in volcanes:
    listbox.insert(i)

listbox.bind("<<ListboxSelect>>", mostrar_seleccion)
root.mainloop()