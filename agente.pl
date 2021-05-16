abrir:- odbc_connect('DSNMySQL',_,[user(root),password(''),alias(bd),open(once)]).
cerrar:- odbc_disconnect(bd).

form:- new(Form,dialog('CRUD MySQL', size(400, 400))),
       new(Label1, text('MENU CRUD MySQL')),
       send(Form,append(Label1)),
       new(GI, dialog_group(' ')),
       new(GB, dialog_group(' ')),
       new(GU, dialog_group(' ')),
       new(GD, dialog_group(' ')),
       send(Form,append,GI),
       send(Form,append,GB,right),
       send(Form,append,GU),
       send(Form,append,GD,right),
       new(FormInsertar,button('insertar',message(@prolog,formInsertar))),
       send(GI,append,FormInsertar),
       new(FormBuscar,button('buscar',message(@prolog,consulta))),
       send(GB,append,FormBuscar),
       new(FormActualizar,button('actualizar',message(@prolog,formActualizar))),
       send(GU,append,FormActualizar),
       new(FormEliminar,button('eliminar',message(@prolog,formEliminar))),
       send(GD,append,FormEliminar),
       send(Form,open).
       
formInsertar:-
       new(Form,dialog('INSERTAR', size(400, 400))),
       new(Label1, text('Insercion')),
       send(Form,append,Label1),
       /*establecer los grupos de dialogos*/
       new(G1, dialog_group(' ')),
       new(G2, dialog_group(' ')),
       /*establer las posiciones de los grupos de dialogos*/
       send(Form,append,G1),
       send(Form,append,G2,right),
       /*primer cuadro de dialogo*/
       new(Padre,text_item('padre:')),
       send(G1,append,Padre),
       /*segundo cuadro de dialogo*/
       new(Hijo,text_item('hijo:')),
       send(G2,append,Hijo),
       new(Resultado,text('resultado:')),
       new(Insertar,button('insertar',message(@prolog,insertar,Padre,Hijo,Resultado))),
       send(Form,append(Insertar)),
       send(Form,append(Resultado)),
       send(Form,open).


insertar(P,H,Res):-abrir,get(P,value,Padre),get(H,value,Hijo),concat("INSERT INTO progenitores(Padre,Hijo) VALUES ('",Padre,C1),
               concat(C1,"','",C2),
               concat(C2,Hijo,C3),
               concat(C3,"')",SQL),
               odbc_query(bd,SQL,affected(R)),
               concat("resultado: Registros insertado en la base de datos: ",R,R2),cerrar,
               send(Res,value,R2).


formBuscar(Padre,Hijo):- new(Form,dialog('Formulario para consultas')),
       new(Label1, text('buscar')),
       send(Form,append(Label1)),
        new(G1, dialog_group(' ')),
        new(G2, dialog_group(' ')),
       /*establer las posiciones de los grupos de dialogos*/
        send(Form,append,G1),
        send(Form,append,G2,right),
        new(ListaPadres,menu('Padres',cycle)),
        send_list(ListaPadres,append,Padre),
        send(G1,append,ListaPadres),
        
        new(ListaHijos,menu('Hijos',cycle)),
        send_list(ListaHijos,append,Hijo),
        send(G2,append,ListaHijos),
        send(Form,open).

consulta:- abrir,findall(P,odbc_query(bd,'SELECT padre FROM progenitores',row(P)),Padre),cerrar,
           abrir,findall(H,odbc_query(bd,'SELECT hijo FROM progenitores',row(H)),Hijo),cerrar,
             formBuscar(Padre,Hijo).
             
             
formActualizar:- new(Form,dialog('Formulario para Actualizar')),
       new(Label1, text('actualizar')),
       send(Form,append(Label1)),
       new(G1, dialog_group(' ')),
       new(G2, dialog_group(' ')),
       /*establer las posiciones de los grupos de dialogos*/
       send(Form,append,G1),
       send(Form,append,G2,right),
       new(Campos,text_item('Campos:')),
       send(G1,append,Campos),
       new(Condicion,text_item('Condicion:')),
       send(G2,append,Condicion),
       new(Resultado,text('Resultado:')),
       new(Ejecutar,button('ejecutar',message(@prolog,actualizar,Campos,Condicion,Resultado))),
       send(Form,append(Ejecutar)),
       send(Form,append(Resultado)),
       send(Form,open).

actualizar(Campos,Condicion,Resultado):- abrir,get(Campos,value,C),abrir,get(Condicion,value,Con),
                      concat("UPDATE progenitores SET ",C,C1),
                      concat(C1," WHERE ",C2),
                      concat(C2,Con,SQL),
                      odbc_query(bd,SQL,affected(R)),
                      concat("Resultado: Registros Actualizados ",R,R2),cerrar,
                      send(Resultado,value,R2).
               
formEliminar:- new(Form,dialog('Formulario para eliminacion')),
       new(Label1, text('eliminar')),
       send(Form,append(Label1)),
       new(Condicion,text_item('Condicion:')),
       new(Resultado,text('Resultado:')),
       new(Ejecutar,button('ejecutar',message(@prolog,eliminar,Condicion,Resultado))),
       send(Form,append(Condicion)),
       send(Form,append(Ejecutar)),
       send(Form,append(Resultado)),
       send(Form,open).

eliminar(Condicion,Resultado):- abrir,get(Condicion,value,C),
                      concat("DELETE FROM progenitores WHERE ",C,SQL),
                      odbc_query(bd,SQL,affected(R)),
                      concat("Resultado: Registros eliminados ",R,R2),cerrar,
                      send(Resultado,value,R2).
