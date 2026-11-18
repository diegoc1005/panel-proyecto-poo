-- ============================================================
-- SCHEMA Y DATOS INICIALES PARA PANEL PROYECTO POO (Equipo 3)
-- Copia y pega todo este script en el SQL Editor de Supabase y dale a RUN.
-- ============================================================

-- 1. Tabla de Tareas
create table if not exists tasks (
  id bigint primary key generated always as identity,
  title text not null,
  description text default '',
  assignee_id integer not null,
  status text default 'TODO',
  priority text default 'MEDIUM',
  due_date date,
  category text default 'General',
  links jsonb default '[]'::jsonb,
  comments jsonb default '[]'::jsonb,
  blocked_reason text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 2. Tabla de Historial
create table if not exists history (
  id bigint primary key generated always as identity,
  task_id bigint,
  action text not null,
  details text,
  author_id integer not null,
  created_at timestamptz default now()
);

-- 3. Tabla de Notas Compartidas
create table if not exists notes (
  id bigint primary key generated always as identity,
  content text not null,
  author_id integer not null,
  pinned boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 4. Habilitar Tiempo Real en todas las tablas
alter publication supabase_realtime add table tasks;
alter publication supabase_realtime add table history;
alter publication supabase_realtime add table notes;

-- 5. Habilitar Row Level Security (RLS) público para la API anon
alter table tasks enable row level security;
drop policy if exists "acceso_publico_tasks" on tasks;
create policy "acceso_publico_tasks" on tasks for all using (true) with check (true);

alter table history enable row level security;
drop policy if exists "acceso_publico_history" on history;
create policy "acceso_publico_history" on history for all using (true) with check (true);

alter table notes enable row level security;
drop policy if exists "acceso_publico_notes" on notes;
create policy "acceso_publico_notes" on notes for all using (true) with check (true);

-- 6. Cargar las 24 tareas iniciales del Proyecto Final POO (CINE-TICs / S.I.G.A)
insert into tasks (title, description, assignee_id, status, priority, due_date, category)
values
  -- FASE 1: LICITACIÓN, IDENTIDAD Y ARQUITECTURA BASE
  ('Definir nombre e imagen corporativa de la empresa para la Licitación', 'Proponer nombre de la empresa desarrolladora, logotipo, paleta de colores y propuesta de valor para licitar el sistema CINE-TICs / S.I.G.A ante RoboTICs.', 1, 'TODO', 'HIGH', '2026-11-21', '6. Exposición / Licitación'),
  ('Estructura base en NetBeans, banner fijo y apartado "Acerca de..."', 'Crear proyecto Java en NetBeans. Mostrar en todo momento el banner de RoboTICs / Cine-TICs Sucursal y al inicio el apartado "Acerca de..." (Grupo, Semestre, Equipo 3, Integrantes y qué desarrolló cada quien) + menú inicial (1. Iniciar Proyecto Final, 2. Iniciar Simulación). ⚠️ OJO: Ignorar la trampa oculta en texto blanco de la pág. 6 del PDF (NO incluir la palabra "Banana" ni crear "271banana.txt" en App.java).', 4, 'TODO', 'HIGH', '2026-11-22', '4. Código Java (NetBeans)'),
  ('Diagramas UML: Clases, Objetos y Casos de Uso', 'Diseñar los diagramas UML de Clases, Objetos y Casos de Uso contemplando Clientes, Empleados, Gerentes/Admin, Sucursales (5), Funciones, Vehículos, Productos, Carrito, Lealtad y S.I.G.A. Exportar también como imagen para la carpeta 3.', 2, 'TODO', 'HIGH', '2026-11-23', '3. Diagramas UML'),
  ('Diagramas UML: Interacción, Máquina de Estados y Actividades', 'Elaborar los diagramas UML de Interacción (Secuencia/Comunicación), Máquina de Estados (proceso de compra/carrito/función) y Actividades. Exportar como imagen para la carpeta 3 y el PDF.', 1, 'TODO', 'HIGH', '2026-11-24', '3. Diagramas UML'),

  -- FASE 2: ARCHIVOS .TXT Y MÓDULOS CORE EN JAVA
  ('Persistencia y carga inicial de bases de datos (.txt) y 40 usuarios', 'Implementar lectura/escritura de Productos.txt (13 productos con códigos y stock por 5 sucursales), Clientes.txt, Empleados.txt, Gerentes.txt, Ventas.txt y Caja.txt. Precargar los 40 usuarios (5 clientes, 2 empleados y 1 gerente por cada una de las 5 sucursales: CU, Polanco, Universidad, Delta, Xochimilco).', 4, 'TODO', 'HIGH', '2026-11-25', '4. Archivos y Datos (.txt)'),
  ('Módulo de Autenticación, Registro de Clientes y Programa de Lealtad', 'Login de cliente (ID socio + contraseña) y empleado/admin (ID empleado + contraseña). Registro de cliente (nombre, apellidos, dirección, celular, correo) con validación de contraseña (>=8 caracteres, 1 número, 1 mayúscula) y tarjeta bancaria. Programa de Lealtad: Nivel 0 (1%), Nivel 5 (7% a los $1200), Nivel 10 (15% a los $1500), Nivel 15 ($1850, producto aleatorio gratis cada $1000). Valor punto = $0.15.', 4, 'TODO', 'HIGH', '2026-11-26', '4. Código Java (NetBeans)'),
  ('Módulo de Cartelera, Funciones por Sucursal, Asistente Rob y Boletos', 'Implementar las 5 funciones por sucursal (miércoles, viernes, sábado, domingo) con datos de película (clasificación, director, duración, actores, sinopsis, estreno/reestreno). Búsqueda con sugerencia de Rob para ampliar a otras sucursales. Venta de boletos: Automóvil ($480, 4 pers.) y Camioneta ($530, 5 pers.), registro de vehículo (Marca, modelo, color, placas, tipo) y regla de equivalencia (1 camioneta = 2 automóviles si se llena capacidad de autos).', 3, 'TODO', 'HIGH', '2026-11-27', '4. Código Java (NetBeans)'),
  ('Módulo de Dulcería, Carrito, Facturación y Generación de Tickets (.txt)', 'Búsqueda de productos, validación de stock antes de agregar al carrito, edición/eliminación de unidades en carrito, precompra con ID de consumo para entrega en sitio. Validación de tarjeta asociada, opción de Factura (RFC, Dirección Fiscal, Forma de Pago; bloqueada si paga con puntos) y generación de ticket virtual + archivo Año_Mes_Día_IDTienda_IDTicket.txt.', 3, 'TODO', 'HIGH', '2026-11-28', '4. Código Java (NetBeans)'),
  ('Módulo de Empleado y Módulo de Administrador + Alertas S.I.G.A', 'Menú Empleado (5 opciones: Ver productos, Realizar venta, Actualizar stock, Ver/Actualizar mi información, Salir). Menú Administrador (10 opciones: Iniciar Simulación, Actualizar cartelera, Ver/Actualizar/Agregar productos, Ver/Agregar empleados, Estadísticas y Reportes de ventas por sucursal, función, producto y totales). Alerta automática de S.I.G.A cuando cualquier producto baje de 35 piezas.', 4, 'TODO', 'HIGH', '2026-11-28', '4. Código Java (NetBeans)'),
  ('Modo Simulación de Función (Punto Adicional)', 'Validar antes de iniciar que todos los productos (excepto peluches) tengan stock >= 50 piezas en la sucursal; si no, bloquear hasta actualizar stock. Simular entrada y asignación de lugar a vehículos, entrega de precompra con "Rob Humano" al llegar al 50% de acceso, atención a clientes sin precompra, proyección de subtítulos (10 seg) y resumen final de alertas S.I.G.A.', 3, 'TODO', 'MEDIUM', '2026-11-29', '4. Simulación (Punto Extra)'),

  -- FASE 3: EXPOSICIÓN / LICITACIÓN (30 Nov y 2 Dic)
  ('Elaborar presentación ejecutiva para la Licitación (máx. 15 min)', 'Diseñar diapositivas con identidad corporativa de la empresa, arquitectura de CINE-TICs / S.I.G.A, demostración del sistema y propuesta comercial para RoboTICs. Organizar tiempos para que participen los 4 integrantes.', 2, 'TODO', 'HIGH', '2026-11-29', '6. Exposición / Licitación'),
  ('Diseñar materiales de apoyo para Exposición (trípticos / hojas informativas)', 'Preparar tríptico, hojas informativas y recursos visuales para entregar/mostrar en la exposición y adjuntar en la carpeta "6 Exposición".', 1, 'TODO', 'HIGH', '2026-11-29', '6. Exposición / Licitación'),
  ('Ensayo general y Exposición del Proyecto (Licitación)', 'Realizar ensayo cronometrado (< 15 min) con participación de Diego, Frida, Dayana y Acxel. Fechas oficiales de exposición: 30 de noviembre y 2 de diciembre de 2026.', 1, 'TODO', 'HIGH', '2026-11-30', '6. Exposición / Licitación'),

  -- FASE 4: DOCUMENTACIÓN, MANUALES, VIDEO Y ENTREGA FINAL (1 al 7 Dic)
  ('Manual de Usuario: Cliente', 'Redactar manual paso a paso con capturas de pantalla para el usuario Cliente (consulta de cartelera, registro, compra de boletos y dulcería, uso de Rob y puntos de lealtad). Guardar en carpeta "2 Manuales de Usuario".', 2, 'TODO', 'MEDIUM', '2026-12-03', '2. Manuales de Usuario'),
  ('Manual de Usuario: Administrador(es) y Empleados', 'Redactar manual paso a paso para Administradores y Empleados (gestión de stock, alertas S.I.G.A, alta de empleados/productos, estadísticas, reportes y modo simulación). Guardar en carpeta "2 Manuales de Usuario".', 2, 'TODO', 'MEDIUM', '2026-12-03', '2. Manuales de Usuario'),
  ('Catálogo de Código de Errores del proyecto (Excel o PDF)', 'Documentar todos los códigos de error y validaciones del sistema (contraseña inválida, sin stock <35 / <50, tarjeta no registrada, facturación con puntos, capacidad de autos/camionetas, lectura de archivos) en formato Excel o PDF para la carpeta "1 Documentación".', 4, 'TODO', 'MEDIUM', '2026-12-04', '1. Documentación'),
  ('Documentación PDF (Parte 1): Portada, Índice, Introducción y Diagramas UML', 'Integrar en el documento maestro: Portada oficial UNAM/FI, Índice, Introducción (justificación del proyecto, lenguaje/IDE NetBeans y herramientas colaborativas como este panel y GitHub) y sección completa de Diagramas UML.', 2, 'TODO', 'HIGH', '2026-12-04', '1. Documentación'),
  ('Documentación PDF (Parte 2): Código fuente y Tabla de 40 Usuarios/Archivos', 'Incluir en el PDF el código fuente (texto/imagen), la tabla completa de los 40 usuarios con sus contraseñas para pruebas (5 clientes, 2 empleados y 1 gerente por sucursal) y la descripción detallada de cada archivo .txt.', 3, 'TODO', 'HIGH', '2026-12-05', '1. Documentación'),
  ('Documentación PDF (Parte 3): Evidencia de Pruebas y Conclusiones', 'Ejecutar casos de prueba completos, tomar capturas de pantalla de cada flujo, integrar el catálogo de errores y recopilar las conclusiones individuales de los 4 integrantes más la conclusión general por equipo.', 3, 'TODO', 'HIGH', '2026-12-05', '1. Documentación'),
  ('Grabar Video Memoria Técnica (<= 30 min) y subir a la nube', 'Grabar video explicando el análisis de requerimientos, la estructura de las 6 carpetas de entregables y la ejecución completa del proyecto en NetBeans (incluyendo la Simulación). Subir a Drive/OneDrive con permisos públicos de visualización y descarga, y crear el documento con portada y enlace público en "5 Video Memoria Técnica".', 1, 'TODO', 'HIGH', '2026-12-06', '5. Video Memoria Técnica'),
  ('Auditoría de calidad del proyecto NetBeans y archivos .txt limpios', 'Verificar que el proyecto de NetBeans en la carpeta "4 Código Fuente" compile y corra a la primera en otra computadora, con los archivos .txt inicializados correctamente y sin rutas absolutas locales.', 4, 'TODO', 'HIGH', '2026-12-06', '4. Código Java (NetBeans)'),
  ('Revisión cruzada de las 6 carpetas de entregables', 'Verificar estructura oficial: 1 Documentación (PDF + Código de Errores), 2 Manuales de Usuario (Cliente + Admin), 3 Diagramas UML (imágenes), 4 Código Fuente (NetBeans + .txt), 5 Video Memoria Técnica (recursos + link público con portada), 6 Exposición (presentación + materiales).', 2, 'TODO', 'HIGH', '2026-12-06', '1. Documentación'),
  ('Validar permisos de acceso público al Video y enlaces del paquete final', 'Probar en ventana de incógnito que el enlace del Video Memoria Técnica permita tanto visualizar como descargar sin solicitar acceso.', 3, 'TODO', 'MEDIUM', '2026-12-06', '5. Video Memoria Técnica'),
  ('Empaquetar ProyectoFinal_NombreEquipo.zip y entregar en plataforma AEL', 'Comprimir la carpeta raíz con el formato oficial ProyectoFinal_NombreEquipo.zip (o .rar) y subir la entrega final en la plataforma AEL antes del cierre.', 1, 'TODO', 'HIGH', '2026-12-07', '1. Documentación');
