# Reflexiones

En este ejercicio se implementaron dos representaciones de una red de Petri:

1. Lista de aristas
2. Mapa de adyacencia

La representación como lista es fácil de implementar, debido a que se
requiere recorrer toda la lista de aristas, el preset y postset son más laboriosos, lo cual puede
ser menos eficiente en redes grandes.

En cambio, la representación como mapa permite acceder rápidamente al postset de un nodo,
ya que se obtiene directamente desde el mapa. Sin embargo, calcular el preset
requiere recorrer el mapa para encontrar los nodos que apuntan a la transición.

Durante la implementación de la función fire, ambas representaciones utilizan
la misma lógica:

M' = (M − preset(t)) ∪ postset(t)

En general, la representación con mapa puede ser más eficiente para acceder
a los vecinos, mientras que la lista de aristas es más simple conceptualmente.