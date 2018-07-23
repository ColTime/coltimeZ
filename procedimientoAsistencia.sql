BEGIN#Global
#Los tiempos de los eventos no se pueden cambir mientras alguna persona este en ejecucion de algune evento.
#El sistema generara alerta de las personas que lleguen tarde del cualquier evento(Laboral, Desayuno o almuerzo). (El evento laboral ya lo genera)
#El sistema cerrar automaticamente las asistencias que pasen el tiempo de cada evento(Laboral, Desayuno o Almuerzo)
#Por el momento no se va a tener en cuenta los permisos.
#Falta implementar la toma de tiempo cuando hay un permiso (Existen dos tipos de permiso, uno de ingreso tarde y otro de salida temprano).
#Validar que si no sale al desayuno le tome en cuenta el siguiente enveto (de desayuno tome almuerzo o del almuerzo tome la salida).
DECLARE doc varchar(13);
DECLARE estadoA tinyint(1);
DECLARE horaI time; #hora de inicio de algun event
DECLARE horaF time; #hora fin de algun evento
DECLARE horaD time;#Hora de inicio del evento Desayuno o almuerzo
DECLARE tiempo varchar(10); #Tiempo total laborado el día de hoy. 
#Buscamos el documendo de la perzona a la cual pertenece la huella (rol =1 =Operario), (estado=1=activado), huellas... 
SET doc=(SELECT e.documento FROM empleado e WHERE e.huella1=huella OR e.huella2=huella OR e.huella3=huella AND e.estado=1 AND e.idRol=1);
#preguntamos si existe alguien con esa huella, si existe alguien con la huella que inserte el registro, si no no va a realizar la inserción.

#Condicional de documento.------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------7
IF doc!='' THEN
   #se valida que la en el día no tenga más de un evento laboral, si lo tiene no se puede volver a registrar el dia actual otro evento de esos.-----------------------------------------------------------------------------------------------------------------8
   IF !EXISTS(SELECT * FROM asistencia a WHERE a.documento=doc AND DATE_FORMAT(a.fecha_inicio,'%d-%m-%Y')=DATE_FORMAT(now(),'%d-%m-%Y') AND a.idTipo_evento=1 AND DATE_FORMAT(a.fecha_fin,'%d-%m-%Y')=DATE_FORMAT(now(),'%d-%m-%Y'))  THEN
   #validamos si existe una asistenca de tipo laboral---------------------------------------------------------------------------------------------------------------------------------------------------------------6
      IF EXISTS(SELECT * FROM asistencia a WHERE a.documento=doc AND DATE_FORMAT(a.fecha_inicio,'%d-%m-%Y')=DATE_FORMAT(now(),'%d-%m-%Y') AND a.fecha_fin is null AND a.hora_fin is null AND a.idTipo_evento=1) THEN 
       #Validacion de cuantos eventos tiene en un dia de evento normal.-------------------------------------------------------------------------------------------------------------------------5
	   #validamos la existencia de los eventos que no se lograron asistir y se generan.    
	   CALL SI_PA_ValidacionEventosNoAsistidos(doc);
	     IF (SELECT COUNT(*) FROM asistencia a WHERE (a.idTipo_evento=2 OR a.idTipo_evento=3) AND DATE_FORMAT(a.fecha_inicio,'%d-%m-%Y')=DATE_FORMAT(now(),'%d-%m-%Y') AND a.documento=doc AND DATE_FORMAT(a.fecha_inicio,'%d-%m-%Y')=DATE_FORMAT(now(),'%d-%m-%Y') AND a.hora_fin is NOT null)=2 THEN #Por lo general puede tener dos eventos cuando trabaja un dia completo pero tambien hay que tener en cuenta que puede tener menos.
              #Validacion de que el ultimo evento de descanso(Almuerzo) tenga menos de 10 minutos más del evento del almeurzo.
			   SET horaI=(SELECT c.hora_fin_almuerzo FROM configuracion c WHERE c.estado=1 LIMIT 1);
			   SET horaF=(SELECT a.hora_fin FROM asistencia a WHERE a.documento=doc AND DATE_FORMAT(a.fecha_inicio,'%d-%m-%Y')=DATE_FORMAT(now(),'%d-%m-%Y') AND a.idTipo_evento=3);
			   #...
			   IF  (TIMEDIFF(TIME_FORMAT(now(),'%H:%i:%s'),horaF)>'00:10:00')=1  THEN # Si termine de almorzar despues del horario del evento y han pasado más de 10 minutos, entonces procedo a cerrar el evento laboral.
			   		   #...
		              #cierra el evento de asistencia Laboral!!!
			          #...
					  select 1;
			          #
 	                  UPDATE asistencia a SET a.fecha_fin=now(), a.hora_fin=now(), a.lectorF=lector, a.estado=0, a.tiempo=tiempo WHERE a.documento=doc AND a.idTipo_evento=1 AND DATE_FORMAT(a.fecha_inicio,'%d-%m-%Y')=DATE_FORMAT(now(),'%d-%m-%Y');
                      #acutualizar el estado del empleado en la empresa a 0=ausente
		              UPDATE empleado e SET e.asistencia=0 WHERE e.documento=doc;
			          #
			          #
                      SET horaI=(SELECT a.hora_inicio FROM asistencia a WHERE a.documento=doc AND DATE_FORMAT(a.fecha_inicio,'%d-%m-%Y')=DATE_FORMAT(now(),'%d-%m-%Y') AND a.idTipo_evento=1);
                      SET horaF=(SELECT a.hora_fin FROM asistencia a WHERE a.documento=doc AND DATE_FORMAT(a.fecha_inicio,'%d-%m-%Y')=DATE_FORMAT(now(),'%d-%m-%Y') AND a.idTipo_evento=1);
                      #
			          SET tiempo= (SELECT TIMEDIFF(horaF,horaI));
			          #select tiempo;
			          #
                      UPDATE asistencia a SET a.tiempo=tiempo WHERE a.documento=doc AND a.idTipo_evento=1 AND DATE_FORMAT(a.fecha_inicio,'%d-%m-%Y')=DATE_FORMAT(now(),'%d-%m-%Y');
                      #...
			            CALL SI_PA_CalcularRegistrarHorasTrabajadas(doc,horaF);
                      #...
			   END IF;
			   #...
         ELSE
            #valida las otras asistencia (Desayuno y almuerzo)
            #validamos si tiene alguna asistencia de Desayuno--------------------------------------------------------------------------------------------------------------------------------4
             IF EXISTS(SELECT * FROM asistencia a WHERE a.documento=doc AND DATE_FORMAT(a.fecha_inicio,'%d-%m-%Y')=DATE_FORMAT(now(),'%d-%m-%Y') AND a.idTipo_evento=2) THEN 
                   # Valida si cierra la toma de tiempo o busca la siguiente asistencia---------------------------------------------------------------------------------------------3
                  IF EXISTS(SELECT * FROM asistencia a WHERE a.documento=doc AND DATE_FORMAT(a.fecha_inicio,'%d-%m-%Y')=DATE_FORMAT(now(),'%d-%m-%Y') AND a.fecha_fin is null AND a.hora_fin is null AND a.idTipo_evento=2) THEN 
                       # cierra la toma de tiempo  Desayuno!!!
 	                   #  
			           #Cierre del evento  de desayuno
			  	       #...
			  		      CALL SI_PA_CierreEventosAsistenciaOperarios(doc, 2, lector);
                      #...
                   ELSE 
   	                  #Se valida si tiene alguna asistencia del evento de Almuerzo--------------------------------------------2
                     IF EXISTS(SELECT * FROM asistencia a WHERE a.documento=doc AND DATE_FORMAT(a.fecha_inicio,'%d-%m-%Y')=DATE_FORMAT(now(),'%d-%m-%Y') AND a.fecha_fin is null AND a.hora_fin is null AND a.idTipo_evento=3) THEN 
   		                 #
			             #Cierra la toma de tiempo  Almuerzo!!!
                         #...
			  	            CALL SI_PA_CierreEventosAsistenciaOperarios(doc, 3, lector);
                         #...
                     ELSE
                         #...
			  	         #Asistencia de tipo evento Almuerzo---------1 
			 			      CALL SI_PA_RegistroEventoAsistencia(doc, 3, lector);
			  	         #/Asistencia de tipo evento Almuerzo----------1
                         #...
                     END IF;
			      #//Se valida si tiene alguna asistencia del evento de Almuerzo fin---------------------------------------2
             END IF;
             # //Valida si cierra la toma de tiempo o busca la siguiente asistencia fin---------------------------------------------------------------------------------3
             ELSE
              #... 
              #asistencia de tipo evento Desayuno
	              CALL SI_PA_RegistroEventoAsistencia(doc, 2 , lector);
	          #asistencia de tipo evento Desayuno
              #...	 
            END IF;
        #validamos si tiene alguna asistencia de Desayuno---------------------------------------------------------------------------------------------------------------------------------4
       END IF;
 #Validacion de cuantos eventos tiene en un dia de evento normal.-------------------------------------------------------------------------------------------------------------------------5    
ELSE 
        #Asistencia de tipo evento Laboral<<<<<
        INSERT INTO `asistencia`(`documento`, `idTipo_evento`, `fecha_inicio`, `hora_inicio`, `fecha_fin`, `hora_fin`,`idEstado_asistencia`, `estado`, `lectorI`) VALUES (doc,1,now(),now(),null,null,1,1,lector);
        UPDATE empleado e SET e.asistencia=1 WHERE e.documento=doc;#acutualizar el estado del empleado en la empresa 1=Presente
        #Clasificaion del tipo de estado de la asistencia
        SET horaI=(SELECT a.hora_inicio FROM asistencia a WHERE a.documento=doc AND DATE_FORMAT(a.fecha_inicio,'%d-%m-%Y')=DATE_FORMAT(now(),'%d-%m-%Y') AND a.idTipo_evento=1);
        SET horaF='00:01:00';#no la va a tomar en cuenta
        SET estadoA=(SELECT SI_FU_ClasificacionEstadoAsistencia(1,horaI,horaF));#Estado de la asistencia para el igreso laboral
	    #...
		#Actualizar el estado del operario que registro la asistencia laboral.
	    UPDATE asistencia a SET a.idEstado_asistencia= estadoA  WHERE a.documento=doc AND a.idTipo_evento=1 AND DATE_FORMAT(a.fecha_inicio,'%d-%m-%Y')=DATE_FORMAT(now(),'%d-%m-%Y');
	    #
		IF estadoA=2 THEN
	        CALL SI_PA_GeneradorDeAlertas();
	    END IF;
		#
	  END IF; 
       #validamos si existe una asistenca de tipo laboral fin---------------------------------------------------------------------------------------------------------------------------------------------------------------6
   END IF;# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------8
END IF;
#Condicional de documento.--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------7
      	  #Retornar el numero de documento de la persona perteneciente a la huella dactilar.
		 SELECT doc;
END