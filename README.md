# project-wea-fome
Platform Unity 2D Fome

How to add weapons :v
-2 gráficos por arma, el del inventario y el que renderiza.
-Agregar un case a los siguintes scripts:
  draw_item(); -Añadir el grafico que renderiza en el inventario
  set_projectile(); -Añadir objeto que lanza en la ejecucion del arma
  set_cost_damage(); -Coste de mana/energia, daño.
Todos los id deben de ser iguales.
Para setear el arma en algun slot, igualar global.slot1 a su ID.
