-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 20-02-2018 a las 20:19:19
-- Versión del servidor: 10.1.29-MariaDB
-- Versión de PHP: 7.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `coltime`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ActualizarProductoPorMinuto` (IN `detalle` INT, IN `negocio` INT, IN `lector` INT, IN `tiempo` VARCHAR(20))  NO SQL
BEGIN
IF negocio=1 THEN

UPDATE detalle_formato_estandar d SET d.tiempo_por_unidad=tiempo WHERE d.detalle_proyecto_idDetalle_proyecto=detalle AND d.Procesos_idproceso=lector;

ELSE
 IF negocio=2 THEN
  
 UPDATE detalle_teclados d SET d.tiempo_por_unidad=tiempo WHERE d.detalle_proyecto_idDetalle_proyecto=detalle AND d.Procesos_idproceso=lector;
 
 ELSE
  
 UPDATE detalle_ensamble d SET d.tiempo_por_unidad=tiempo WHERE d.detalle_proyecto_idDetalle_proyecto=detalle AND d.Procesos_idproceso=lector;
 
 END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ActualizarTiempoTotalPorUnidad` (IN `detalle` INT, IN `tiempo` VARCHAR(20))  NO SQL
UPDATE detalle_proyecto dp SET dp.Total_timepo_Unidad=tiempo WHERE dp.idDetalle_proyecto=detalle$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ActualizarTiempoTotalProducto` (IN `detalle` INT, IN `cadena` VARCHAR(20))  NO SQL
BEGIN

UPDATE detalle_proyecto dp SET dp.tiempo_total=cadena WHERE dp.idDetalle_proyecto=detalle;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CalcularTiempoMinutos` (IN `orden` INT, IN `detalle` INT, IN `lector` INT, IN `busqueda` INT)  NO SQL
BEGIN
DECLARE id int;

IF busqueda=1 THEN

SET id=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector);

 UPDATE detalle_formato_estandar f SET  f.hora_terminacion=CURRENT_TIME WHERE f.idDetalle_formato_estandar=id;

SELECT f.tiempo_total_por_proceso,TIME_FORMAT(TIMEDIFF(TIME_FORMAT(f.hora_terminacion,'%H:%i:%s'),TIME_FORMAT(f.hora_ejecucion,'%H:%i:%s')),'%H:%i:%s') as diferencia from detalle_formato_estandar f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4;


ELSE
 IF busqueda=2 THEN
 
SET id=(SELECT f.idDetalle_teclados from detalle_teclados f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector);

 UPDATE detalle_teclados f SET  f.hora_terminacion=CURRENT_TIME WHERE f.idDetalle_teclados=id;

SELECT f.tiempo_total_proceso,TIME_FORMAT(TIMEDIFF(TIME_FORMAT(f.hora_terminacion,'%H:%i:%s'),TIME_FORMAT(f.hora_ejecucion,'%H:%i:%s')),'%H:%i:%s') as diferencia from detalle_teclados f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4;

 ELSE
  IF busqueda=3 THEN
  
  SET id=(SELECT f.idDetalle_ensamble from detalle_ensamble f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector);

 UPDATE detalle_ensamble f SET  f.hora_terminacion=CURRENT_TIME WHERE f.idDetalle_ensamble=id;
  
  SELECT f.tiempo_total_por_proceso,TIME_FORMAT(TIMEDIFF(TIME_FORMAT(f.hora_terminacion,'%H:%i:%s'),TIME_FORMAT(f.hora_ejecucion,'%H:%i:%s')),'%H:%i:%s') as diferencia from detalle_ensamble f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4;
  
  END IF;
 
 END IF;

END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CambiarEstadoDeProductos` (IN `negocio` INT, IN `detalle` INT)  NO SQL
BEGIN
DECLARE iniciar int;
DECLARE pausar int;
DECLARE terminar int;
DECLARE ejecucion int;
SET iniciar=(SELECT d.pro_porIniciar FROM detalle_proyecto d WHERE d.idDetalle_proyecto=detalle);
SET pausar=(SELECT d.pro_Pausado FROM detalle_proyecto d WHERE d.idDetalle_proyecto=detalle);
SET ejecucion=(SELECT d.pro_Ejecucion FROM detalle_proyecto d WHERE d.idDetalle_proyecto=detalle);
SET terminar=(SELECT d.pro_Terminado FROM detalle_proyecto d WHERE d.idDetalle_proyecto=detalle);

IF negocio=1 OR negocio=4 THEN 

IF iniciar!=0 AND pausar=0 AND ejecucion=0 and terminar=0 THEN
  UPDATE detalle_proyecto d SET d.estado_idestado=1 WHERE d.idDetalle_proyecto=detalle;
ELSE
 IF ejecucion>=1 THEN
  UPDATE detalle_proyecto d SET d.estado_idestado=4 WHERE d.idDetalle_proyecto=detalle;
 ELSE
   IF pausar!=0 and ejecucion=0 and (terminar=0 or terminar!=0) THEN
  UPDATE detalle_proyecto d SET d.estado_idestado=2 WHERE d.idDetalle_proyecto=detalle; 
  ELSE
   IF pausar=0 and ejecucion=0 and terminar!=0 AND iniciar!=0 THEN
   UPDATE detalle_proyecto d SET d.estado_idestado=2 WHERE d.idDetalle_proyecto=detalle;
   ELSE
        IF (iniciar+pausar+ejecucion+terminar)=terminar AND iniciar=0 AND pausar=0 and ejecucion=0 THEN
  UPDATE detalle_proyecto d SET d.estado_idestado=3,d.fecha_salida=(SELECT now()) WHERE d.idDetalle_proyecto=detalle;  
    END IF;
   END IF;
  END IF;
 END IF;
END IF;  
 

ELSE
 IF negocio=2 or negocio=3 THEN

  IF iniciar!=0 AND pausar=0 AND ejecucion=0 and terminar=0 THEN
  UPDATE detalle_proyecto d SET d.estado_idestado=1 WHERE d.idDetalle_proyecto=detalle;
  END IF;


IF ejecucion >= 1  THEN
UPDATE detalle_proyecto d SET d.estado_idestado=4 WHERE d.idDetalle_proyecto=detalle;
ELSE
 IF pausar!=0 and ejecucion=0 and (terminar!=0 or terminar=0) THEN
    UPDATE detalle_proyecto d SET d.estado_idestado=2 WHERE d.idDetalle_proyecto=detalle;
 ELSE
  IF terminar!=0 AND ejecucion=0 AND pausar=0 THEN
        CALL PA_CambiarEstadoTerminadoTEIN(negocio,detalle);
   END IF;
 END IF;
END IF;

 END IF;
END IF;

CALL PA_CambiarEstadoDeProyecto((SELECT d.proyecto_numero_orden FROM detalle_proyecto d where d.idDetalle_proyecto=detalle));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CambiarEstadoDeProyecto` (IN `orden` INT)  NO SQL
BEGIN

DECLARE iniciar int;
DECLARE pausar int;
DECLARE ejecucion int;
DECLARE terminado int;
DECLARE fecha date;
DECLARE estado varchar(13);

SET iniciar=(SELECT COUNT(*) FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden AND d.estado_idestado=1);
SET pausar=(SELECT COUNT(*) FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden AND d.estado_idestado=2);
SET terminado=(SELECT COUNT(*) FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden AND d.estado_idestado=3);
SET ejecucion=(SELECT COUNT(*) FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden AND d.estado_idestado=4);
SET fecha=(SELECT p.NFEE FROM proyecto p WHERE p.numero_orden=orden);
SET estado=(SELECT p.estadoEmpresa FROM proyecto p WHERE p.numero_orden=orden);

IF estado IS null OR (estado !='Retraso' AND estado !='A tiempo') THEN
   UPDATE proyecto p SET p.estadoEmpresa='A tiempo' WHERE p.numero_orden = orden;
END IF;

IF iniciar!=0 AND pausar=0 AND ejecucion=0 and terminado=0 THEN
  UPDATE proyecto p SET p.estado_idestado=1, p.fecha_salidal=null WHERE p.numero_orden = orden;
	UPDATE proyecto p SET p.estadoEmpresa=null WHERE p.numero_orden = orden;
ELSE
 IF ejecucion>=1 THEN
  UPDATE proyecto p SET p.estado_idestado=4, p.fecha_salidal=null WHERE p.numero_orden = orden;

 ELSE
   IF pausar!=0 and ejecucion=0 and (terminado=0 or terminado!=0) THEN
  UPDATE proyecto p SET p.estado_idestado=2, p.fecha_salidal=null WHERE p.numero_orden = orden; 

  ELSE
   IF pausar=0 and ejecucion=0 and terminado!=0 AND iniciar!=0 THEN
   UPDATE proyecto p SET p.estado_idestado=2, p.fecha_salidal=null WHERE p.numero_orden = orden; 

   ELSE
        IF (iniciar+pausar+ejecucion+terminado)=terminado AND iniciar=0 AND pausar=0 and ejecucion=0 THEN
  	UPDATE proyecto p SET p.estado_idestado=3, p.fecha_salidal=(SELECT NOW()) WHERE p.numero_orden = orden; 

    END IF;
   END IF;
  END IF;
 END IF;
END IF; 


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CambiarEstadoTerminadoTEIN` (IN `negocio` INT, IN `detalle` INT)  NO SQL
BEGIN
DECLARE res boolean;
IF negocio=2 THEN
  IF EXISTS(SELECT d.estado_idestado FROM detalle_teclados d where    d.detalle_proyecto_idDetalle_proyecto=detalle AND d.Procesos_idproceso=14 AND d.estado_idestado=3) THEN#El 14 es el proceso

 SET res= true;
 
 ELSE 

 SET res = false;

 END IF;

ELSE 
  IF negocio=3 THEN
 IF EXISTS(SELECT d.estado_idestado FROM detalle_ensamble d where    d.detalle_proyecto_idDetalle_proyecto=detalle AND d.Procesos_idproceso=18 AND d.estado_idestado=3) THEN#El 18 ese el proceso

 SET res= true;
 
 ELSE 

 SET res = false;
  
  END IF;
  
 END IF;
END IF;


IF res THEN

 UPDATE detalle_proyecto p SET p.estado_idestado=3,p.fecha_salida=(SELECT now())  where p.idDetalle_proyecto=detalle;
ELSE
  UPDATE detalle_proyecto p SET p.estado_idestado=2 where p.idDetalle_proyecto=detalle;

END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CantidadProyectosEjecucion` ()  NO SQL
BEGIN

SELECT COUNT(*),dp.negocio_idnegocio FROM detalle_proyecto dp JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE dp.estado_idestado=4 AND dp.PNC=0 and p.eliminacion=1 GROUP BY dp.negocio_idnegocio;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CantidadProyectosIngresadosArea` ()  NO SQL
BEGIN

SELECT COUNT(dp.idDetalle_proyecto) as catidadIngresada ,dp.negocio_idnegocio FROM detalle_proyecto dp JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE DATE_FORMAT(p.fecha_ingreso,'%Y -%m -%d')=DATE_FORMAT(CURDATE(),'%Y -%m -%d')  and p.eliminacion=1 GROUP BY dp.negocio_idnegocio;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CantidadProyectosPorIniciar` ()  NO SQL
BEGIN

SELECT COUNT(*),dp.negocio_idnegocio FROM detalle_proyecto dp JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE dp.estado_idestado=1 AND dp.PNC=0 and p.eliminacion=1 GROUP BY dp.negocio_idnegocio;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CantidadProyectosterminadosHoy` ()  NO SQL
BEGIN
DECLARE FE INT;
DECLARE TE INT;
DECLARE EN INT;
DECLARE AL INT;

SET FE =(SELECT COUNT(*) FROM detalle_formato_estandar df JOIN detalle_proyecto dp ON df.detalle_proyecto_idDetalle_proyecto=dp.idDetalle_proyecto JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE DATE_FORMAT(df.fecha_fin,'%Y-%m-%d')=DATE_FORMAT(CURRENT_DATE,'%Y-%m-%d') AND df.Procesos_idproceso=10 AND dp.estado_idestado=3 AND df.estado_idestado=3 and p.eliminacion=1);

SET TE =(SELECT COUNT(*) FROM detalle_teclados dt JOIN detalle_proyecto dp ON dt.detalle_proyecto_idDetalle_proyecto=dp.idDetalle_proyecto JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE DATE_FORMAT(dt.fecha_fin,'%Y-%m-%d')=DATE_FORMAT(CURRENT_DATE,'%Y-%m-%d') AND dt.Procesos_idproceso=14 AND dp.estado_idestado=3 AND dt.estado_idestado=3 and p.eliminacion=1);

SET EN =(SELECT COUNT(*) FROM detalle_ensamble de JOIN detalle_proyecto dp ON de.detalle_proyecto_idDetalle_proyecto=dp.idDetalle_proyecto JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE DATE_FORMAT(de.fecha_fin,'%Y-%m-%d')=DATE_FORMAT(CURRENT_DATE,'%Y-%m-%d') AND de.Procesos_idproceso=18 AND dp.estado_idestado=3 AND de.estado_idestado=3 and p.eliminacion=1);

SET AL =(SELECT COUNT(*) FROM almacen de JOIN detalle_proyecto dp ON de.detalle_proyecto_idDetalle_proyecto=dp.idDetalle_proyecto JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE DATE_FORMAT(de.fecha_fin,'%Y-%m-%d')=DATE_FORMAT(CURRENT_DATE,'%Y-%m-%d') AND dp.estado_idestado=3 AND de.estado_idestado=3 and p.eliminacion=1);

SELECT FE,TE,EN,AL;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CantidadUnidadesProyecto` (IN `orden` INT)  NO SQL
BEGIN
DECLARE total int;

SET total=(SELECT SUM(sp.canitadad_total) FROM detalle_proyecto sp WHERE sp.proyecto_numero_orden=orden AND sp.negocio_idnegocio!=4);

SELECT total;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarDetalleProyecto` (IN `orden` INT(11), IN `estado` INT)  NO SQL
BEGIN

IF estado=0 THEN
SELECT d.idDetalle_proyecto,n.nom_negocio,t.nombre,d.canitadad_total,e.nombre as estado, d.PNC,d.ubicacion,d.material,p.parada FROM tipo_negocio t  JOIN detalle_proyecto d on t.idtipo_negocio=d.tipo_negocio_idtipo_negocio JOIN negocio n on d.negocio_idnegocio=n.idnegocio JOIN estado e on d.estado_idestado=e.idestado JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden WHERE d.proyecto_numero_orden=orden;
ELSE
SELECT d.idDetalle_proyecto,n.nom_negocio,t.nombre,d.canitadad_total,e.nombre as estado, d.PNC,d.ubicacion,d.material,p.parada FROM tipo_negocio t  JOIN detalle_proyecto d on t.idtipo_negocio=d.tipo_negocio_idtipo_negocio JOIN negocio n on d.negocio_idnegocio=n.idnegocio JOIN estado e on d.estado_idestado=e.idestado JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden WHERE d.proyecto_numero_orden=orden and p.eliminacion=1;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarDetallesProyectosProduccion` (IN `area` INT, IN `op` INT)  NO SQL
BEGIN

IF op=1 THEN
 #Estados del proyecto solo numero 1
SELECT d.proyecto_numero_orden,t.nombre,d.estado_idestado,p.tipo_proyecto FROM tipo_negocio t JOIN detalle_proyecto d ON t.idtipo_negocio=d.tipo_negocio_idtipo_negocio JOIN proyecto p ON p.numero_orden=d.proyecto_numero_orden WHERE d.negocio_idnegocio=area AND d.PNC=0 AND p.eliminacion=1 AND d.estado_idestado=1;

ELSE
 IF op=3 THEN
#Estados del proyecto numero 3
SELECT d.proyecto_numero_orden,t.nombre,d.estado_idestado,p.tipo_proyecto FROM tipo_negocio t JOIN detalle_proyecto d ON t.idtipo_negocio=d.tipo_negocio_idtipo_negocio JOIN proyecto p ON p.numero_orden=d.proyecto_numero_orden WHERE d.negocio_idnegocio=area AND DATE_FORMAT(d.fecha_salida,'%Y-%m-%d')=DATE_FORMAT(CURRENT_DATE,'%Y-%m-%d') AND d.PNC=0 AND p.eliminacion=1;

 ELSE
  IF op=2 THEN
  #Esados del proyecto solo numero 2
 SELECT d.proyecto_numero_orden,t.nombre,d.estado_idestado,p.tipo_proyecto FROM tipo_negocio t JOIN detalle_proyecto d ON t.idtipo_negocio=d.tipo_negocio_idtipo_negocio JOIN proyecto p ON p.numero_orden=d.proyecto_numero_orden WHERE d.negocio_idnegocio=area AND d.PNC=0 AND p.eliminacion=1 AND d.estado_idestado=2;
  ELSE
   #Esados del proyecto solo numero 4
 SELECT d.proyecto_numero_orden,t.nombre,d.estado_idestado,p.tipo_proyecto FROM tipo_negocio t JOIN detalle_proyecto d ON t.idtipo_negocio=d.tipo_negocio_idtipo_negocio JOIN proyecto p ON p.numero_orden=d.proyecto_numero_orden WHERE d.negocio_idnegocio=area AND d.PNC=0 AND p.eliminacion=1 AND d.estado_idestado=4;
  END IF;
  
 END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarIDProcesosTEYEN` (IN `area` INT)  NO SQL
BEGIN

SELECT p.idproceso FROM procesos p WHERE p.negocio_idnegocio=area and p.estado=1; 

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarImagenUsuario` (IN `doc` VARCHAR(13))  NO SQL
BEGIN

SELECT u.imagen from usuario u WHERE u.numero_documento=doc;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarIndormacionQR` (IN `orden` INT)  NO SQL
BEGIN
select p.idDetalle_proyecto,d.idDetalle_formato_estandar,d.Procesos_idproceso from detalle_proyecto p INNER JOIN detalle_formato_estandar d ON p.idDetalle_proyecto=d.detalle_proyecto_idDetalle_proyecto where p.proyecto_numero_orden=orden;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarNumeroOrden` ()  NO SQL
SHOW TABLE STATUS like 'proyecto'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProcesos` ()  NO SQL
BEGIN

SELECT * FROM procesos p ORDER BY p.idproceso ASC;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProcesosFE` (IN `detalle` INT)  NO SQL
begin

SELECT p.nombre_proceso FROM detalle_formato_estandar f JOIN procesos p on f.Procesos_idproceso=p.idproceso WHERE f.detalle_proyecto_idDetalle_proyecto=detalle;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProyectosEliminados` ()  NO SQL
BEGIN

SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.eliminacion=0;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProyectosEntrega` (IN `orden` INT, IN `nombreC` VARCHAR(45), IN `nombreP` VARCHAR(45), IN `fecha` VARCHAR(10))  NO SQL
BEGIN

IF orden='' and nombreC='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.eliminacion=1;
ELSE
  IF orden!='' and nombreC='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.eliminacion=1;
  ELSE 
    IF orden='' and nombreC!='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.eliminacion=1;
    ELSE
      IF orden='' and nombreC='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteo,p.antisolder,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
       ELSE
         IF orden!='' and nombreC!='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.eliminacion=1;
	      ELSE
            IF orden='' and nombreC!='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
            ELSE
              IF orden!='' and nombreC='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') and 
p.eliminacion=1;
              ELSE 
                IF orden!='' and nombreC!='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
                ELSE
                  IF orden='' and nombreC='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;
				  ELSE
                    IF orden!='' and nombreC='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;
 					ELSE
                      IF orden='' and nombreC!='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;                     					  ELSE
					     IF orden='' and nombreC='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
                          ELSE
                            IF orden!='' and nombreC!='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
						     ELSE
                               IF orden!='' and nombreC='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
                               ELSE
                                 IF orden='' and nombreC!='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;
                                 ELSE
                                   IF orden!='' and nombreC!='' and nombreP!='' and fecha!='' THEN 
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;                                   
                                   END IF;
                                 END IF;
                               END IF;
                            END IF;
                         END IF;
                      END IF;
                    END IF;
                  END IF;
                END IF;
              END IF;
            END IF;
         END IF;
      END IF; 
    END IF;
  END IF;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProyectosIngreso` (IN `orden` INT, IN `nombreC` VARCHAR(45), IN `nombreP` VARCHAR(45), IN `fecha` VARCHAR(10))  NO SQL
BEGIN 

IF orden='' and nombreC='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.eliminacion=1; 
ELSE
  IF orden!='' and nombreC='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.eliminacion=1;
  ELSE 
    IF orden='' and nombreC!='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.eliminacion=1;
    ELSE
      IF orden='' and nombreC='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
       ELSE
         IF orden!='' and nombreC!='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.eliminacion=1;
	      ELSE
            IF orden='' and nombreC!='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
            ELSE
              IF orden!='' and nombreC='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
              ELSE
                IF orden!='' and nombreC!='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
                ELSE
                  IF orden='' and nombreC='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;
				  ELSE
                    IF orden!='' and nombreC='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;
 					ELSE
                      IF orden='' and nombreC!='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;                     					  ELSE
					     IF orden='' and nombreC='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
                          ELSE
                            IF orden!='' and nombreC!='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
						     ELSE
                               IF orden!='' and nombreC='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
                               ELSE
                                 IF orden='' and nombreC!='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;
                                 ELSE
                                   IF orden!='' and nombreC!='' and nombreP!='' and fecha!='' THEN 
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;                                   
                                   END IF;
                                 END IF;
                               END IF;
                            END IF;
                         END IF;
                      END IF;
                    END IF;
                  END IF;
                END IF;
              END IF;
            END IF;
         END IF;
      END IF; 
    END IF;
  END IF;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProyectosSalida` (IN `orden` INT, IN `nombreC` VARCHAR(45), IN `nombreP` VARCHAR(45), IN `fecha` VARCHAR(10))  NO SQL
BEGIN

IF orden='' and nombreC='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.eliminacion=1;
ELSE
  IF orden!='' and nombreC='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.eliminacion=1;
  ELSE 
    IF orden='' and nombreC!='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.eliminacion=1;
    ELSE
      IF orden='' and nombreC='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
       ELSE
         IF orden!='' and nombreC!='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.eliminacion=1;
	      ELSE
            IF orden='' and nombreC!='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
            ELSE
              IF orden!='' and nombreC='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
              ELSE
                IF orden!='' and nombreC!='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
                ELSE
                  IF orden='' and nombreC='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;
				  ELSE
                    IF orden!='' and nombreC='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;
 					ELSE
                      IF orden='' and nombreC!='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;                     					  ELSE
					     IF orden='' and nombreC='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
                          ELSE
                            IF orden!='' and nombreC!='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
						     ELSE
                               IF orden!='' and nombreC='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
                               ELSE
                                 IF orden='' and nombreC!='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;
                                 ELSE
                                   IF orden!='' and nombreC!='' and nombreP!='' and fecha!='' THEN 
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;                                   
                                   END IF;
                                 END IF;
                               END IF;
                            END IF;
                         END IF;
                      END IF;
                    END IF;
                  END IF;
                END IF;
              END IF;
            END IF;
         END IF;
      END IF; 
    END IF;
  END IF;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarPuertoSerialUsuario` (IN `documento` VARCHAR(13))  NO SQL
BEGIN

IF (EXISTS(SELECT * FROM usuariopuerto up WHERE up.documentousario=documento)) THEN

SELECT up.usuarioPuerto FROM usuariopuerto up WHERE up.documentousario=documento;

ELSE
#No existe ningun ususario que guarda alguen puerto serial
SELECT '' AS vacio;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarUsuarios` (IN `doc` VARCHAR(13), IN `nombreApe` VARCHAR(50), IN `cargo` TINYINT)  NO SQL
IF doc='' AND nombreApe='' and cargo=0 THEN
SELECT u.numero_documento,u.tipo_documento,u.nombres,u.apellidos,c.nombre,u.imagen,u.estado,u.recuperacion,u.sesion FROM usuario u INNER JOIN cargo c on u.cargo_idcargo=c.idcargo;
ELSE
  IF doc!='' AND nombreApe='' and cargo=0 THEN
	SELECT u.numero_documento,u.tipo_documento,u.nombres,u.apellidos,c.nombre,u.imagen,u.estado,u.recuperacion,u.sesion FROM usuario u INNER JOIN cargo c on u.cargo_idcargo=c.idcargo WHERE u.numero_documento LIKE CONCAT(doc, '%');
 ELSE
     IF doc='' AND nombreApe!='' and cargo=0 THEN 
	  SELECT u.numero_documento,u.tipo_documento,u.nombres,u.apellidos,c.nombre,u.imagen,u.estado,u.recuperacion,u.sesion FROM usuario u INNER JOIN cargo c on u.cargo_idcargo=c.idcargo WHERE u.nombres like CONCAT('%', nombreApe, '%') or u.apellidos like CONCAT('%', nombreApe, '%');
     ELSE
        IF doc='' AND nombreApe='' and cargo!=0 THEN
        	  SELECT u.numero_documento,u.tipo_documento,u.nombres,u.apellidos,c.nombre,u.imagen,u.estado,u.recuperacion,u.sesion FROM usuario u INNER JOIN cargo c on u.cargo_idcargo=c.idcargo WHERE u.cargo_idcargo =cargo;
        ELSE
            IF doc='' AND nombreApe!='' and cargo!=0 THEN
            	  SELECT u.numero_documento,u.tipo_documento,u.nombres,u.apellidos,c.nombre,u.imagen,u.estado,u.recuperacion,u.sesion FROM usuario u INNER JOIN cargo c on u.cargo_idcargo=c.idcargo WHERE u.cargo_idcargo =cargo AND u.nombres like CONCAT('%', nombreApe, '%') or u.apellidos like CONCAT('%', nombreApe, '%');
             ELSE
              IF doc!='' AND nombreApe!='' and cargo!=0 THEN
                          	  SELECT u.numero_documento,u.tipo_documento,u.nombres,u.apellidos,c.nombre,u.imagen,u.estado,u.recuperacion,u.sesion FROM usuario u INNER JOIN cargo c on u.cargo_idcargo=c.idcargo WHERE u.cargo_idcargo =cargo AND u.numero_documento LIKE CONCAT(doc, '%') AND (u.nombres like CONCAT('%', nombreApe, '%') or u.apellidos like CONCAT('%', nombreApe, '%'));         ELSE
                  IF doc!='' AND nombreApe='' and cargo!=0 THEN
                                        	  SELECT u.numero_documento,u.tipo_documento,u.nombres,u.apellidos,c.nombre,u.imagen,u.estado,u.recuperacion,u.sesion FROM usuario u INNER JOIN cargo c on u.cargo_idcargo=c.idcargo WHERE u.cargo_idcargo =cargo AND u.numero_documento LIKE CONCAT(doc, '%');
                    ELSE
                    IF doc!='' AND nombreApe!='' and cargo=0 THEN
                     SELECT u.numero_documento,u.tipo_documento,u.nombres,u.apellidos,c.nombre,u.imagen,u.estado,u.recuperacion,u.sesion FROM usuario u INNER JOIN cargo c on u.cargo_idcargo=c.idcargo WHERE u.numero_documento LIKE CONCAT(doc, '%') AND u.nombres like CONCAT('%', nombreApe, '%') or u.apellidos like CONCAT('%', nombreApe, '%');
                    END IF;
                  END IF;
              END IF;
            END IF;
        END IF;
    END IF;
  END IF;
END IF$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DetalleDelDetalleDelproyecto` (IN `detalle` INT, IN `negocio` INT)  NO SQL
BEGIN

IF negocio=1 THEN
SELECT p.nombre_proceso,Date_Format(f.fecha_inicio,'%d-%M-%Y') as inicio,Date_format(f.fecha_fin,'%d-%M-%Y') as fin,f.cantidad_terminada,f.tiempo_total_por_proceso,f.tiempo_por_unidad,e.nombre as estado,TIME_FORMAT(f.hora_ejecucion,'%r'),TIME_FORMAT(TIMEDIFF(CURRENT_TIME,f.hora_ejecucion),'%H:%i:%s') as tiempoActual,TIME_FORMAT(f.hora_terminacion,'%r') as "hora terminacion",TIME_FORMAT(TIMEDIFF(TIME_FORMAT(f.hora_terminacion,'%H:%i:%s'),TIME_FORMAT(f.hora_ejecucion,'%H:%i:%s')),'%H:%i:%s') as InicioTerminadoIntervalo,f.idDetalle_formato_estandar,f.restantes,f.noperarios FROM detalle_formato_estandar f JOIN procesos p on f.Procesos_idproceso=p.idproceso JOIN estado e on f.estado_idestado=e.idestado where f.detalle_proyecto_idDetalle_proyecto=detalle ORDER BY f.Procesos_idproceso ASC;
ELSE
  IF negocio=2 THEN
  SELECT p.nombre_proceso,Date_Format(f.fecha_inicio,'%d-%M-%Y'),Date_format(f.fecha_fin,'%d-%M-%Y'),f.cantidad_terminada,f.tiempo_total_proceso,f.tiempo_por_unidad,e.nombre,TIME_FORMAT(f.hora_ejecucion,'%r'),TIME_FORMAT(TIMEDIFF(CURRENT_TIME,f.hora_ejecucion),'%H:%i:%s'),TIME_FORMAT(f.hora_terminacion,'%r'),TIME_FORMAT(TIMEDIFF(f.hora_terminacion,f.hora_ejecucion),'%H:%i:%s'),f.idDetalle_teclados,f.restantes,f.noperarios FROM detalle_teclados f JOIN procesos p on f.Procesos_idproceso=p.idproceso JOIN estado e on f.estado_idestado=e.idestado where f.detalle_proyecto_idDetalle_proyecto=detalle ORDER BY f.Procesos_idproceso ASC;
  ELSE
   IF negocio=3 THEN
SELECT p.nombre_proceso,Date_Format(f.fecha_inicio,'%d-%M-%Y'),Date_format(f.fecha_fin,'%d-%M-%Y'),f.cantidad_terminada,f.tiempo_total_por_proceso,f.tiempo_por_unidad,e.nombre,TIME_FORMAT(f.hora_ejecucion,'%r'),TIME_FORMAT(TIMEDIFF(CURRENT_TIME,f.hora_ejecucion),'%H:%i:%s'),TIME_FORMAT(f.hora_terminacion,'%r'),TIME_FORMAT(TIMEDIFF(f.hora_terminacion,f.hora_ejecucion),'%H:%i:%s'),f.idDetalle_ensamble,f.restantes,f.noperarios FROM detalle_ensamble f JOIN procesos p on f.Procesos_idproceso=p.idproceso JOIN estado e on f.estado_idestado=e.idestado where f.detalle_proyecto_idDetalle_proyecto=detalle ORDER BY f.Procesos_idproceso ASC;
   ELSE
    IF negocio=4 THEN
    SELECT p.nombre_proceso,Date_Format(al.fecha_inicio,'%d-%M-%Y'),Date_format(al.fecha_fin,'%d-%M-%Y'),al.cantidad_recibida,al.tiempo_total_proceso,al.tiempo_total_proceso,e.nombre,TIME_FORMAT(al.hora_registro,'%r'),datediff(CURRENT_DATE,al.fecha_inicio) as dias,TIME_FORMAT(al.hora_llegada,'%r'),datediff(al.fecha_fin,al.fecha_inicio),al.idalmacen FROM almacen al JOIN procesos p on al.Procesos_idproceso=p.idproceso JOIN estado e on al.estado_idestado=e.idestado where al.detalle_proyecto_idDetalle_proyecto=detalle ORDER BY al.Procesos_idproceso ASC;
    END IF;
   END IF;
  END IF;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DetalleDeLosProcesosDeEnsamble` (IN `orden` INT, IN `tipo` INT, IN `ubic` VARCHAR(50))  NO SQL
BEGIN

DECLARE detalle int;

IF ubic='' THEN
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.tipo_negocio_idtipo_negocio=tipo AND dd.negocio_idnegocio=3 AND dd.ubicacion is null));

ELSE
 
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.tipo_negocio_idtipo_negocio=tipo AND dd.negocio_idnegocio=3 AND dd.ubicacion=ubic));

END IF;


UPDATE detalle_proyecto SET pro_porIniciar=(SELECT COUNT(e.idDetalle_ensamble) FROM detalle_ensamble e WHERE e.detalle_proyecto_idDetalle_proyecto=detalle) WHERE idDetalle_proyecto=detalle;

CALL PA_CambiarEstadoDeProductos(3,detalle);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DetalleDeLosProcesosDeTeclados` (IN `orden` INT, IN `tipo` INT, IN `ubic` VARCHAR(50))  NO SQL
BEGIN

DECLARE detalle int;

IF ubic='' THEN
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.tipo_negocio_idtipo_negocio=tipo AND dd.negocio_idnegocio=2 AND dd.ubicacion is null));

ELSE
 
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.tipo_negocio_idtipo_negocio=tipo AND dd.negocio_idnegocio=2 AND dd.ubicacion=ubic));

END IF;

UPDATE detalle_proyecto SET pro_porIniciar=(SELECT COUNT(e.idDetalle_teclados) FROM detalle_teclados e WHERE e.detalle_proyecto_idDetalle_proyecto=detalle) WHERE idDetalle_proyecto=detalle;

CALL PA_CambiarEstadoDeProductos(2,detalle);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DetalleDeProduccionProyectosActivos` (IN `orden` INT, IN `negocio` INT, IN `pnc` INT)  NO SQL
BEGIN

SELECT d.idDetalle_proyecto,t.nombre,d.estado_idestado,d.negocio_idnegocio  FROM detalle_proyecto d JOIN tipo_negocio t on d.tipo_negocio_idtipo_negocio=t.idtipo_negocio WHERE d.proyecto_numero_orden=orden and d.negocio_idnegocio=negocio AND d.PNC=pnc AND d.estado_idestado=4;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DetalleProyectosProduccion` (IN `orden` INT, IN `negocio` INT, IN `pnc` INT)  NO SQL
BEGIN
IF negocio >=1 AND negocio <=4 THEN
SELECT d.idDetalle_proyecto,t.nombre,d.estado_idestado,d.negocio_idnegocio  FROM detalle_proyecto d JOIN tipo_negocio t on d.tipo_negocio_idtipo_negocio=t.idtipo_negocio WHERE d.proyecto_numero_orden=orden and d.negocio_idnegocio=negocio AND d.PNC=pnc;

ELSE
SELECT d.idDetalle_proyecto,t.nombre,d.estado_idestado,d.negocio_idnegocio  FROM detalle_proyecto d JOIN tipo_negocio t on d.tipo_negocio_idtipo_negocio=t.idtipo_negocio WHERE d.proyecto_numero_orden=orden AND d.PNC=pnc;

END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DetallesEnEjecucion` (IN `orden` INT, IN `estado` INT)  NO SQL
BEGIN

IF estado=4 THEN
SELECT dp.idDetalle_proyecto,dp.negocio_idnegocio FROM detalle_proyecto dp WHERE dp.proyecto_numero_orden=orden AND dp.estado_idestado=estado;

ELSE

SELECT dp.idDetalle_proyecto,dp.negocio_idnegocio FROM detalle_proyecto dp WHERE dp.proyecto_numero_orden=orden AND dp.estado_idestado=estado AND dp.negocio_idnegocio=4;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DetallesparaValidarEstado` (IN `orden` INT)  NO SQL
BEGIN

SELECT dp.idDetalle_proyecto,dp.negocio_idnegocio FROM detalle_proyecto dp WHERE dp.proyecto_numero_orden=orden; 

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DiagramaFETEEN` (IN `op` INT)  NO SQL
BEGIN

IF op=1 THEN

SELECT df.Procesos_idproceso,COUNT(*),df.estado_idestado FROM detalle_formato_estandar df JOIN detalle_proyecto dp ON df.detalle_proyecto_idDetalle_proyecto=dp.idDetalle_proyecto JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE df.estado_idestado!=3 AND p.eliminacion=1 GROUP BY df.Procesos_idproceso,df.estado_idestado ORDER BY df.Procesos_idproceso ASC;

ELSE

IF op=2 THEN
SELECT dt.Procesos_idproceso,COUNT(*),dt.estado_idestado FROM detalle_teclados dt JOIN detalle_proyecto dp ON dt.detalle_proyecto_idDetalle_proyecto=dp.idDetalle_proyecto JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE dt.estado_idestado!=3 AND p.eliminacion=1 AND dp.estado_idestado!=3 GROUP BY dt.Procesos_idproceso,dt.estado_idestado ORDER BY dt.Procesos_idproceso ASC;

END IF;
SELECT de.Procesos_idproceso,COUNT(*),de.estado_idestado FROM detalle_ensamble de JOIN detalle_proyecto dp ON de.detalle_proyecto_idDetalle_proyecto=dp.idDetalle_proyecto JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE de.estado_idestado!=3 AND dp.estado_idestado!=3 AND p.eliminacion=1 GROUP BY de.Procesos_idproceso,de.estado_idestado ORDER BY de.Procesos_idproceso ASC;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_Diagramas` (IN `inicio` VARCHAR(11), IN `fin` VARCHAR(11))  NO SQL
BEGIN

IF inicio='' AND fin='' THEN
SELECT COUNT(*),d.negocio_idnegocio FROM detalle_proyecto d JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden WHERE p.eliminacion=1 GROUP BY d.negocio_idnegocio;
ELSE
 IF inicio!='' AND fin='' THEN
  SELECT COUNT(*),d.negocio_idnegocio FROM detalle_proyecto d JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden WHERE p.eliminacion=1 AND DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y')= DATE_FORMAT(inicio,'%d-%M-%Y') GROUP BY d.negocio_idnegocio;
 ELSE
  IF inicio!='' AND fin!='' THEN
  SELECT COUNT(*),d.negocio_idnegocio FROM detalle_proyecto d JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden WHERE p.eliminacion=1 AND DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y') BETWEEN DATE_FORMAT(inicio,'%d-%M-%Y') AND DATE_FORMAT(fin,'%d-%M-%Y')  GROUP BY d.negocio_idnegocio; 
  END IF;
 END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_EjecucionoParada` (IN `orden` INT, IN `op` INT)  NO SQL
BEGIN

UPDATE proyecto p SET p.parada=op WHERE p.numero_orden=orden;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_EliminarCambiarEstadoProyecto` (IN `orden` INT)  NO SQL
BEGIN
UPDATE proyecto p SET p.eliminacion=0 WHERE p.numero_orden=orden;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_EliminarProductosNoConformes` (IN `orden` INT, IN `tipo` INT, IN `negocio` INT)  NO SQL
BEGIN

SELECT d.idDetalle_proyecto FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden AND d.tipo_negocio_idtipo_negocio=tipo AND d.negocio_idnegocio=negocio;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_FechaServidor` ()  NO SQL
SELECT DATE_FORMAT(CURDATE(),'%d-%M-%Y')$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ImagenUsuario` (IN `ruta` VARCHAR(250), IN `doc` VARCHAR(13))  NO SQL
BEGIN

UPDATE usuario u SET u.imagen=ruta WHERE u.numero_documento=doc;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformacionDeTodaElAreaDeProduccion` ()  NO SQL
BEGIN
DECLARE cantidadP int;
SET cantidadP=(SELECT COUNT(numero_orden) FROM proyecto p WHERE p.eliminacion=1);

SELECT  DATE_FORMAT(CURDATE(),'%d-%M-%Y') as fecha,COUNT(*) as cantidad,cantidadP,d.negocio_idnegocio FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden WHERE d.PNC=0 AND p.eliminacion=1 GROUP BY d.negocio_idnegocio ORDER BY d.negocio_idnegocio ASC;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformacionFiltrariaDetalleProyecto` (IN `iddetalle` INT)  NO SQL
BEGIN

SELECT p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y') as fechaIngreso,DATE_FORMAT(p.fecha_entrega,'%d-%M-%Y')AS fechaEntrega,dp.canitadad_total,dp.tiempo_total,DATE_FORMAT(p.entregaCircuitoFEoGF,'%d-%M-%Y') AS fecha1,DATE_FORMAT(p.entregaCOMCircuito,'%d-%M-%Y') AS fecha2,DATE_FORMAT(p.entregaPCBFEoGF,'%d-%M-%Y') AS fecha3,DATE_FORMAT(p.entregaPCBCom,'%d-%M-%Y') AS fecha4 FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden WHERE dp.idDetalle_proyecto=iddetalle;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformacionProyectosProduccion` (IN `negocio` INT, IN `orden` INT, IN `clien` VARCHAR(40), IN `proyecto` VARCHAR(40), IN `tipo` VARCHAR(6))  NO SQL
BEGIN

IF orden=0 AND clien='' AND proyecto='' AND tipo='' THEN
  SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT join proyecto p ON p.numero_orden=d.proyecto_numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) and p.eliminacion=1;
ELSE
 IF orden!=0 AND clien='' AND proyecto='' AND tipo='' THEN
 	 SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT join proyecto p ON p.numero_orden=d.proyecto_numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND d.proyecto_numero_orden LIKE CONCAT(orden,'%') and p.eliminacion=1;
 ELSE
  IF orden=0 AND clien!='' AND proyecto='' AND tipo='' THEN
SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where  ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) and p.nombre_cliente LIKE CONCAT('%',clien,'%') and p.eliminacion=1;
  ELSE
   IF orden=0 AND clien='' AND proyecto!='' AND tipo='' THEN
   	  SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND p.nombre_proyecto LIKE CONCAT(proyecto,'%') and p.eliminacion=1;
   ELSE
    IF orden=0 AND clien='' AND proyecto='' AND tipo!='' THEN
       SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND p.tipo_proyecto=tipo and p.eliminacion=1;
    ELSE
     IF orden!=0 AND clien!='' AND proyecto='' AND tipo='' THEN
        SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND d.proyecto_numero_orden LIKE CONCAT(orden,'%') AND p.nombre_cliente LIKE CONCAT('%',clien,'%') AND p.eliminacion=1;
     ELSE 
      IF orden!=0 AND clien='' AND proyecto!='' AND tipo='' THEN
        SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND d.proyecto_numero_orden LIKE CONCAT(orden,'%') AND p.nombre_proyecto LIKE CONCAT(proyecto,'%') and p.eliminacion=1;
      ELSE
       IF orden!=0 AND clien='' AND proyecto='' AND tipo!='' THEN
       	 SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND d.proyecto_numero_orden LIKE CONCAT(orden,'%') AND p.tipo_proyecto=tipo and p.eliminacion=1;
       ELSE
        IF orden=0 AND clien!='' AND proyecto!='' AND tipo='' THEN
          SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND p.nombre_cliente LIKE      CONCAT('%',clien,'%') AND p.nombre_proyecto LIKE CONCAT(proyecto,'%') and p.eliminacion=1;
        ELSE
         IF orden=0 AND clien!='' AND proyecto='' AND tipo!='' THEN
           SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND p.nombre_cliente LIKE      CONCAT('%',clien,'%') AND p.tipo_proyecto=tipo and p.eliminacion=1;
         ELSE
          IF orden=0 AND clien='' AND proyecto!='' AND tipo!='' THEN
            SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND p.nombre_proyecto LIKE    CONCAT(proyecto,'%') AND p.tipo_proyecto=tipo AND p.eliminacion=1;
          ELSE
           IF orden!=0 AND clien!='' AND proyecto!='' AND tipo='' THEN
           SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND d.proyecto_numero_orden LIKE CONCAT(orden,'%') AND p.nombre_proyecto LIKE CONCAT(proyecto,'%') AND p.nombre_cliente LIKE CONCAT('%',clien,'%') AND p.eliminacion=1;
           ELSE
            IF orden=0 AND clien!='' AND proyecto!='' AND tipo!='' THEN
             SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND p.tipo_proyecto=tipo AND p.nombre_proyecto LIKE CONCAT(proyecto,'%') AND p.nombre_cliente LIKE CONCAT('%',clien,'%') and p.eliminacion=1;
            ELSE
             IF orden!=0 AND clien='' AND proyecto!='' AND tipo!='' THEN
           SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND d.proyecto_numero_orden LIKE CONCAT(orden,'%') AND p.nombre_proyecto LIKE CONCAT(proyecto,'%') AND p.tipo_proyecto=tipo AND p.eliminacion=1;
             ELSE
              IF orden!=0 AND clien!='' AND proyecto='' AND tipo!='' THEN
           SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on 
d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND d.proyecto_numero_orden LIKE CONCAT(orden,'%') AND p.nombre_cliente LIKE 
CONCAT('%',clien,'%') AND p.tipo_proyecto=tipo AND p.eliminacion=1;
              ELSE
               IF orden!=0 AND clien!='' AND proyecto!='' AND tipo!='' THEN
           SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on 
d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND d.proyecto_numero_orden LIKE CONCAT(orden,'%') AND p.nombre_cliente LIKE 
CONCAT('%',clien,'%') AND p.nombre_cliente LIKE CONCAT(proyecto,'%') AND p.tipo_proyecto=tipo AND                             p.eliminacion=1;
               END IF;
              END IF;
             END IF;
            END IF; 
           END IF;
          END IF; 
         END IF; 
        END IF;
       END IF;
      END IF;
     END IF;
    END IF;
   END IF;
  END IF;
 END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformacionQR` (IN `orden` INT)  NO SQL
BEGIN
SELECT d.idDetalle_proyecto,d.tipo_negocio_idtipo_negocio,d.negocio_idnegocio from detalle_proyecto d JOIN tipo_negocio t ON d.tipo_negocio_idtipo_negocio=t.idtipo_negocio where d.proyecto_numero_orden=orden and d.PNC=0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformeDeProduccionEN` (IN `orden` INT)  NO SQL
BEGIN

IF orden=0 THEN
SELECT dp.proyecto_numero_orden,n.nom_negocio,tn.nombre,MAX(de.Procesos_idproceso) AS proceso,DATEDIFF(p.fecha_entrega,CURRENT_DATE) AS dias,dp.estado_idestado FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden JOIN detalle_ensamble de ON dp.idDetalle_proyecto=de.detalle_proyecto_idDetalle_proyecto JOIN negocio n ON dp.negocio_idnegocio=n.idnegocio JOIN tipo_negocio tn ON dp.tipo_negocio_idtipo_negocio=tn.idtipo_negocio WHERE dp.PNC=0 AND p.estado_idestado!=3 AND p.eliminacion=1 AND de.estado_idestado!=1 GROUP BY dp.proyecto_numero_orden, dp.tipo_negocio_idtipo_negocio;

ELSE
SELECT dp.proyecto_numero_orden,n.nom_negocio,tn.nombre,MAX(de.Procesos_idproceso) AS proceso,DATEDIFF(p.fecha_entrega,CURRENT_DATE) AS dias,dp.estado_idestado FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden JOIN detalle_ensamble de ON dp.idDetalle_proyecto=de.detalle_proyecto_idDetalle_proyecto JOIN negocio n ON dp.negocio_idnegocio=n.idnegocio JOIN tipo_negocio tn ON dp.tipo_negocio_idtipo_negocio=tn.idtipo_negocio WHERE dp.proyecto_numero_orden LIKE CONCAT(orden,'%') AND dp.PNC=0 AND p.estado_idestado!=3 AND p.eliminacion=1 AND de.estado_idestado!=1 GROUP BY dp.proyecto_numero_orden, dp.tipo_negocio_idtipo_negocio;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformeDeProduccionFE` (IN `orden` INT)  NO SQL
BEGIN


IF orden= 0 THEN
SELECT dp.proyecto_numero_orden,n.nom_negocio,tn.nombre,MAX(df.Procesos_idproceso) AS proceso,DATEDIFF(p.fecha_entrega,CURRENT_DATE) AS dias,dp.estado_idestado FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden JOIN detalle_formato_estandar df ON dp.idDetalle_proyecto=df.detalle_proyecto_idDetalle_proyecto JOIN negocio n ON dp.negocio_idnegocio=n.idnegocio JOIN tipo_negocio tn ON dp.tipo_negocio_idtipo_negocio=tn.idtipo_negocio WHERE dp.PNC=0 AND p.estado_idestado!=3 AND p.eliminacion=1 AND df.estado_idestado!=1 GROUP BY dp.proyecto_numero_orden, dp.tipo_negocio_idtipo_negocio;

ELSE
SELECT dp.proyecto_numero_orden,n.nom_negocio,tn.nombre,MAX(df.Procesos_idproceso) AS proceso,DATEDIFF(p.fecha_entrega,CURRENT_DATE) AS dias,dp.estado_idestado FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden JOIN detalle_formato_estandar df ON dp.idDetalle_proyecto=df.detalle_proyecto_idDetalle_proyecto JOIN negocio n ON dp.negocio_idnegocio=n.idnegocio JOIN tipo_negocio tn ON dp.tipo_negocio_idtipo_negocio=tn.idtipo_negocio WHERE dp.proyecto_numero_orden LIKE CONCAT(orden,'%') AND dp.PNC=0 AND p.estado_idestado!=3 AND p.eliminacion=1 AND df.estado_idestado!=1 GROUP BY dp.proyecto_numero_orden, dp.tipo_negocio_idtipo_negocio;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformeDeProduccionTE` (IN `orden` INT)  NO SQL
BEGIN

IF orden=0 THEN
SELECT dp.proyecto_numero_orden,n.nom_negocio,tn.nombre,MAX(dt.Procesos_idproceso) AS proceso,DATEDIFF(p.fecha_entrega,CURRENT_DATE) AS dias,dp.estado_idestado FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden JOIN detalle_teclados dt ON dp.idDetalle_proyecto=dt.detalle_proyecto_idDetalle_proyecto JOIN negocio n ON dp.negocio_idnegocio=n.idnegocio JOIN tipo_negocio tn ON dp.tipo_negocio_idtipo_negocio=tn.idtipo_negocio WHERE dp.PNC=0 AND p.estado_idestado!=3 AND p.eliminacion=1 AND dt.estado_idestado!=1 GROUP BY dp.proyecto_numero_orden, dp.tipo_negocio_idtipo_negocio;

ELSE
SELECT dp.proyecto_numero_orden,n.nom_negocio,tn.nombre,MAX(dt.Procesos_idproceso) AS proceso,DATEDIFF(p.fecha_entrega,CURRENT_DATE) AS dias,dp.estado_idestado FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden JOIN detalle_teclados dt ON dp.idDetalle_proyecto=dt.detalle_proyecto_idDetalle_proyecto JOIN negocio n ON dp.negocio_idnegocio=n.idnegocio JOIN tipo_negocio tn ON dp.tipo_negocio_idtipo_negocio=tn.idtipo_negocio WHERE dp.proyecto_numero_orden LIKE CONCAT(orden,'%') AND dp.PNC=0 AND p.estado_idestado!=3 AND p.eliminacion=1 AND dt.estado_idestado!=1 GROUP BY dp.proyecto_numero_orden, dp.tipo_negocio_idtipo_negocio;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformeFinalColtime` ()  NO SQL
BEGIN

SELECT p.numero_orden AS orden,p.nombre_cliente AS cliente,dp.idDetalle_proyecto AS proyecto,dp.tipo_negocio_idtipo_negocio AS producto,p.fecha_ingreso AS ingreso,p.fecha_entrega AS entrega,dp.estado_idestado AS estadoDetalle,df.Procesos_idproceso AS formatoEstandar,df.cantidad_terminada,dt.Procesos_idproceso as Teclados,dt.cantidad_terminada,de.Procesos_idproceso as Ensamble,de.cantidad_terminada FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden LEFT JOIN detalle_formato_estandar df ON dp.idDetalle_proyecto=df.detalle_proyecto_idDetalle_proyecto LEFT JOIN detalle_teclados dt ON dp.idDetalle_proyecto=dt.detalle_proyecto_idDetalle_proyecto LEFT JOIN detalle_ensamble de ON dp.idDetalle_proyecto=de.detalle_proyecto_idDetalle_proyecto;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformeGeneralColtime` ()  NO SQL
BEGIN

#SELECT p.numero_orden AS orden,p.parada AS parada,p.nombre_cliente AS cliente,p.nombre_proyecto AS proyecto,dp.idDetalle_proyecto AS proyecto,dp.negocio_idnegocio AS negocio,DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d') AS ingreso,p.fecha_entrega AS entrega,p.estadoEmpresa AS subEstado,p.NFEE AS NFEE,dp.estado_idestado AS estadoDetalle,dp.tipo_negocio_idtipo_negocio AS tipoNegocio,df.Procesos_idproceso AS formatoEstandar,df.cantidad_terminada,dt.Procesos_idproceso as Teclados,dt.cantidad_terminada,de.Procesos_idproceso as Ensamble,de.cantidad_terminada FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden LEFT JOIN detalle_formato_estandar df ON dp.idDetalle_proyecto=df.detalle_proyecto_idDetalle_proyecto LEFT JOIN detalle_teclados dt ON dp.idDetalle_proyecto=dt.detalle_proyecto_idDetalle_proyecto LEFT JOIN detalle_ensamble de ON dp.idDetalle_proyecto=de.detalle_proyecto_idDetalle_proyecto;

SELECT p.numero_orden AS orden,p.parada AS parada,p.nombre_cliente AS cliente,p.nombre_proyecto AS proyecto,dp.idDetalle_proyecto AS proyecto,dp.negocio_idnegocio AS negocio,DATE_FORMAT(p.fecha_ingreso,'%d/%m/%Y') AS ingreso,DATE_FORMAT(p.fecha_entrega,'%d/%m/%Y') AS entrega,p.estadoEmpresa AS subEstado,DATE_FORMAT(p.NFEE,'%d/%m/%Y') AS NFEE,dp.estado_idestado AS estadoDetalle,dp.tipo_negocio_idtipo_negocio AS tipoNegocio,df.Procesos_idproceso AS formatoEstandar,df.cantidad_terminada,dt.Procesos_idproceso as Teclados,dt.cantidad_terminada,de.Procesos_idproceso as Ensamble,de.cantidad_terminada,dp.canitadad_total FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden LEFT JOIN detalle_formato_estandar df ON dp.idDetalle_proyecto=df.detalle_proyecto_idDetalle_proyecto LEFT JOIN detalle_teclados dt ON dp.idDetalle_proyecto=dt.detalle_proyecto_idDetalle_proyecto LEFT JOIN detalle_ensamble de ON dp.idDetalle_proyecto=de.detalle_proyecto_idDetalle_proyecto WHERE p.estado_idestado!=3 and dp.negocio_idnegocio!=4 AND p.eliminacion!=0  ORDER BY p.numero_orden,df.idDetalle_formato_estandar,dt.Procesos_idproceso,de.Procesos_idproceso,dp.tipo_negocio_idtipo_negocio,dp.estado_idestado;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformeNFE` ()  NO SQL
BEGIN

#SELECT p.numero_orden,d.material,p.tipo_proyecto,tn.nombre as tipoNegocio,d.canitadad_total,df.cantidad_terminada,df.Procesos_idproceso,df.estado_idestado,d.PNC FROM proyecto p RIGHT JOIN detalle_proyecto d ON p.numero_orden=d.proyecto_numero_orden JOIN detalle_formato_estandar df ON d.idDetalle_proyecto=df.detalle_proyecto_idDetalle_proyecto JOIN tipo_negocio tn on d.tipo_negocio_idtipo_negocio=tn.idtipo_negocio WHERE d.negocio_idnegocio=1 AND p.eliminacion=1 AND d.estado_idestado!=3 GROUP BY d.idDetalle_proyecto,df.Procesos_idproceso ORDER BY d.proyecto_numero_orden ASC;
SELECT d.proyecto_numero_orden,d.material,p.tipo_proyecto,tn.nombre,d.canitadad_total,df.cantidad_terminada,df.Procesos_idproceso,df.estado_idestado,d.ubicacion FROM detalle_formato_estandar df RIGHT JOIN detalle_proyecto d ON df.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto LEFT JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden JOIN tipo_negocio tn on d.tipo_negocio_idtipo_negocio=tn.idtipo_negocio where d.negocio_idnegocio=1 AND p.eliminacion=1 AND d.estado_idestado!=3 GROUP BY d.idDetalle_proyecto,df.Procesos_idproceso ORDER BY d.proyecto_numero_orden,tn.nombre,d.PNC,d.ubicacion;
# AND df.fecha_fin is null
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_IniciarRenaudarTomaDeTiempoProcesos` (IN `orden` INT, IN `detalle` INT, IN `lector` INT, IN `busqueda` INT, IN `oper` INT(3))  NO SQL
BEGIN
DECLARE id int;
DECLARE id1 int;
DECLARE cantidadp int;

IF busqueda=1 THEN

set id=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=1);

set id1=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=2);

IF id !='null' THEN
UPDATE detalle_formato_estandar f SET f.fecha_inicio=CURDATE(), f.estado_idestado=4, f.hora_ejecucion=CURRENT_TIME,f.noperarios=oper WHERE f.idDetalle_formato_estandar=id;
END IF;

IF id1 !='null' THEN
UPDATE detalle_formato_estandar f SET  f.estado_idestado=4, f.hora_ejecucion=CURRENT_TIME,f.hora_terminacion=null,f.noperarios=oper WHERE f.idDetalle_formato_estandar=id1;
END IF;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalle;

ELSE
  IF busqueda=2 THEN
  
  set id=(SELECT f.idDetalle_teclados from detalle_teclados f LEFT JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=1);

set id1=(SELECT f.idDetalle_teclados from detalle_teclados f LEFT JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=2);

IF id !='null' THEN
UPDATE detalle_teclados f SET f.fecha_inicio=CURDATE(), f.estado_idestado=4, f.hora_ejecucion=CURRENT_TIME,f.noperarios=oper WHERE f.idDetalle_teclados=id ;
END IF;

IF id1 !='null' THEN
UPDATE detalle_teclados f SET f.estado_idestado=4, f.hora_ejecucion=CURRENT_TIME,f.hora_terminacion=null,f.noperarios=oper WHERE f.idDetalle_teclados=id1 ;
END IF;
  
  SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalle;
  
  ELSE 
    IF busqueda =3 THEN
    
set id=(SELECT f.idDetalle_ensamble from detalle_ensamble f LEFT JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=1);

set id1=(SELECT f.idDetalle_ensamble from detalle_ensamble f LEFT JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=2); 

IF id !='null' THEN
UPDATE detalle_ensamble f SET f.fecha_inicio=CURDATE(), f.estado_idestado=4, f.hora_ejecucion=CURRENT_TIME,f.noperarios=oper WHERE f.idDetalle_ensamble=id;
END IF;

IF id1 !='null' THEN
UPDATE detalle_ensamble f SET  f.estado_idestado=4, f.hora_ejecucion=CURRENT_TIME,f.hora_terminacion=null,f.noperarios=oper WHERE f.idDetalle_ensamble=id1 ;
END IF;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalle;
 
    
    END IF;  
  END IF;
END IF;
            CALL PA_CambiarEstadoDeProductos(busqueda,detalle);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_IniciarTomaTiempoDetalleAlmacen` (IN `detalle` INT)  NO SQL
BEGIN

UPDATE almacen a SET a.estado_idestado=4 WHERE a.detalle_proyecto_idDetalle_proyecto=detalle;

 UPDATE detalle_proyecto dp SET pro_Pausado=0,pro_Ejecucion=1 WHERE idDetalle_proyecto=detalle; 

CALL PA_CambiarEstadoDeProductos(4,detalle);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ModificarDetalleFormatoEstandar` (IN `orden` INT, IN `detalle` INT, IN `material` VARCHAR(2))  NO SQL
BEGIN

IF EXISTS(SELECT * FROM detalle_formato_estandar d  WHERE d.detalle_proyecto_idDetalle_proyecto=detalle AND d.Procesos_idproceso=2) THEN   
  IF material = 'FV' then
        DELETE FROM detalle_formato_estandar  WHERE detalle_proyecto_idDetalle_proyecto=detalle and Procesos_idproceso=2; 
              END IF;
ELSE
    IF material='TH' then
              INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES ('00:00','00:00','0',detalle,2,1);
   END IF;
END IF;

  

IF (SELECT tipo_negocio_idtipo_negocio from detalle_proyecto WHERE proyecto_numero_orden=orden and idDetalle_proyecto=detalle
)=1  THEN


  IF (SELECT ruteoC from proyecto WHERE numero_orden=orden)=1 THEN
    
     IF (SELECT f.Procesos_idproceso from detalle_proyecto d JOIN detalle_formato_estandar f ON 
     d.idDetalle_proyecto=f.detalle_proyecto_idDetalle_proyecto WHERE d.proyecto_numero_orden=orden and 
     f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=9) THEN         
	   select "hola1";    
      ELSE
     INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, 
     `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
     ('00:00','00:00','0',detalle,9,1);
    END IF;
       
    ELSE
       
      IF (SELECT f.Procesos_idproceso from detalle_proyecto d JOIN detalle_formato_estandar f ON 
      d.idDetalle_proyecto=f.detalle_proyecto_idDetalle_proyecto WHERE d.proyecto_numero_orden=orden and 
      f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=9) THEN
        DELETE FROM detalle_formato_estandar  WHERE detalle_proyecto_idDetalle_proyecto=detalle and Procesos_idproceso=9; 
      END IF;
    
  END IF;
  
 IF (SELECT antisolderC from proyecto WHERE numero_orden=orden)=1 THEN
    
     IF (SELECT f.Procesos_idproceso from detalle_proyecto d JOIN detalle_formato_estandar f ON 
     d.idDetalle_proyecto=f.detalle_proyecto_idDetalle_proyecto WHERE d.proyecto_numero_orden=orden and 
     f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=6) THEN         
	   select "hola1";    
      ELSE
     INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, 
     `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
     ('00:00','00:00','0',detalle,6,1);
    END IF;
       
    ELSE
       
      IF (SELECT f.Procesos_idproceso from detalle_proyecto d JOIN detalle_formato_estandar f ON 
      d.idDetalle_proyecto=f.detalle_proyecto_idDetalle_proyecto WHERE d.proyecto_numero_orden=orden and 
      f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=6) THEN
        DELETE FROM detalle_formato_estandar  WHERE detalle_proyecto_idDetalle_proyecto=detalle and Procesos_idproceso=6; 
      END IF;
    
  END IF;


    ELSE
    

  IF (SELECT ruteoP from proyecto WHERE numero_orden=orden)=1 THEN
    
     IF (SELECT f.Procesos_idproceso from detalle_proyecto d JOIN detalle_formato_estandar f ON 
     d.idDetalle_proyecto=f.detalle_proyecto_idDetalle_proyecto WHERE d.proyecto_numero_orden=orden and 
     f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=9) THEN         
	   select "hola1";    
      ELSE
     INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, 
     `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
     ('00:00','00:00','0',detalle,9,1);
    END IF;
       
    ELSE
       
      IF (SELECT f.Procesos_idproceso from detalle_proyecto d JOIN detalle_formato_estandar f ON 
      d.idDetalle_proyecto=f.detalle_proyecto_idDetalle_proyecto WHERE d.proyecto_numero_orden=orden and 
      f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=9) THEN
        DELETE FROM detalle_formato_estandar  WHERE detalle_proyecto_idDetalle_proyecto=detalle and Procesos_idproceso=9; 
      END IF;
    
  END IF;

 IF (SELECT antisolderP from proyecto WHERE numero_orden=orden)=1 THEN
    
     IF (SELECT f.Procesos_idproceso from detalle_proyecto d JOIN detalle_formato_estandar f ON 
     d.idDetalle_proyecto=f.detalle_proyecto_idDetalle_proyecto WHERE d.proyecto_numero_orden=orden and 
     f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=6) THEN         
	   select "hola1";    
      ELSE
     INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, 
     `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
     ('00:00','00:00','0',detalle,6,1);
    END IF;
       
    ELSE
       
      IF (SELECT f.Procesos_idproceso from detalle_proyecto d JOIN detalle_formato_estandar f ON 
      d.idDetalle_proyecto=f.detalle_proyecto_idDetalle_proyecto WHERE d.proyecto_numero_orden=orden and 
      f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=6) THEN
        DELETE FROM detalle_formato_estandar  WHERE detalle_proyecto_idDetalle_proyecto=detalle and Procesos_idproceso=6; 
      END IF;
    
  END IF;

END IF;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_NombreUsuario` (IN `doc` VARCHAR(13))  NO SQL
BEGIN

SELECT u.nombres FROM usuario u WHERE u.numero_documento=doc;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_NumeroOperarios` (IN `detalle` INT, IN `lector` INT, IN `negocio` INT)  NO SQL
BEGIN

IF negocio=1 THEN
SELECT f.noperarios FROM detalle_formato_estandar f WHERE f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=lector;
ELSE
 IF negocio=2 THEN
  SELECT f.noperarios FROM detalle_teclados f WHERE f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=lector;
 ELSE
  SELECT f.noperarios FROM detalle_ensamble f WHERE f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=lector;
 END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_PararTomaDeTiempoAlmacen` (IN `detalle` INT, IN `proceso` INT, IN `cantidad` INT, IN `estado` INT)  NO SQL
BEGIN
DECLARE fecha varchar(11);
IF estado=3 THEN
SET fecha=(SELECT datediff(CURRENT_DATE,al.fecha_inicio) FROM almacen al WHERE al.detalle_proyecto_idDetalle_proyecto=detalle AND al.Procesos_idproceso=proceso);

UPDATE almacen a SET a.fecha_fin=CURRENT_DATE, a.hora_llegada=CURRENT_TIME,a.cantidad_recibida=cantidad,a.estado_idestado=3,a.tiempo_total_proceso=datediff(CURRENT_DATE,a.fecha_inicio) WHERE a.detalle_proyecto_idDetalle_proyecto=detalle AND a.Procesos_idproceso=proceso;

UPDATE detalle_proyecto SET pro_Terminado=1 WHERE idDetalle_proyecto=detalle;

UPDATE detalle_proyecto  SET pro_Ejecucion=0 WHERE idDetalle_proyecto=detalle;

UPDATE detalle_proyecto dp SET dp.tiempo_total=fecha WHERE dp.idDetalle_proyecto=detalle; 

ELSE
 IF estado=2 THEN
  UPDATE almacen a SET a.estado_idestado=2 WHERE a.detalle_proyecto_idDetalle_proyecto=detalle;
 UPDATE detalle_proyecto dp SET pro_Pausado=1,pro_Ejecucion=0 WHERE idDetalle_proyecto=detalle; 
 
 else
UPDATE almacen a SET a.cantidad_recibida=cantidad,a.estado_idestado=4 WHERE a.detalle_proyecto_idDetalle_proyecto=detalle AND a.Procesos_idproceso=proceso;

UPDATE detalle_proyecto  SET pro_Ejecucion=1 WHERE idDetalle_proyecto=detalle; 
 
 END IF;
END IF;

CALL PA_CambiarEstadoDeProductos(4,detalle);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_PausarTomaDeTiempoDeProcesos` (IN `orden` INT, IN `detalle` INT, IN `lector` INT, IN `busqueda` INT, IN `tiempo` VARCHAR(8), IN `cantidad` INT, IN `est` TINYINT(1), IN `res` INT(6))  NO SQL
BEGIN
DECLARE id int;
DECLARE cantidadp int;
IF est=2 THEN

IF busqueda=1 THEN

SET id=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
 
 UPDATE detalle_formato_estandar f SET  f.estado_idestado=est, f.tiempo_total_por_proceso=tiempo,f.cantidad_terminada=cantidad,f.restantes=res,f.noperarios=0 WHERE f.idDetalle_formato_estandar=id ;

ELSE
 IF busqueda=2 THEN
 
 SET id=(SELECT f.idDetalle_teclados from detalle_teclados f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
 
 UPDATE detalle_teclados f SET  f.estado_idestado=est, f.tiempo_total_proceso=tiempo, f.cantidad_terminada=cantidad,f.restantes=res,f.noperarios=0 WHERE f.idDetalle_teclados=id ;
 
 ELSE
  IF busqueda=3 THEN
  
  SET id=(SELECT f.idDetalle_ensamble from detalle_ensamble f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
  
  UPDATE detalle_ensamble f SET  f.estado_idestado=est, f.tiempo_total_por_proceso=tiempo,f.cantidad_terminada=cantidad,f.restantes=res,f.noperarios=0 WHERE f.idDetalle_ensamble=id ;
  
  END IF; 
 END IF;
END IF;

ELSE

IF busqueda=1 THEN

SET id=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
 
 UPDATE detalle_formato_estandar f SET  f.estado_idestado=est,f.fecha_fin=CURRENT_DATE,f.tiempo_total_por_proceso=tiempo,f.cantidad_terminada=cantidad,f.restantes=res,f.noperarios=0 WHERE f.idDetalle_formato_estandar=id ;

ELSE
 IF busqueda=2 THEN
 
 SET id=(SELECT f.idDetalle_teclados from detalle_teclados f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
 
 UPDATE detalle_teclados f SET  f.estado_idestado=est,f.fecha_fin=CURRENT_DATE, f.tiempo_total_proceso=tiempo, f.cantidad_terminada=cantidad,f.restantes=res,f.noperarios=0 WHERE f.idDetalle_teclados=id ;
 
 ELSE
  IF busqueda=3 THEN
  
  SET id=(SELECT f.idDetalle_ensamble from detalle_ensamble f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
  
  UPDATE detalle_ensamble f SET  f.estado_idestado=est,f.fecha_fin=CURRENT_DATE, f.tiempo_total_por_proceso=tiempo,f.cantidad_terminada=cantidad,f.restantes=res,f.noperarios=0 WHERE f.idDetalle_ensamble=id;
  
  END IF; 
 END IF;
END IF;

END IF;

IF busqueda=1 THEN

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalle;

ELSE
 IF busqueda=2 THEN
 
 SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalle;
 
 ELSE
  if busqueda=3 THEN
  
  SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalle;
  
  END IF;
 END IF;
END IF;
     CALL PA_CambiarEstadoDeProductos(busqueda,detalle);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_PromedioProductoPorMinuto` (IN `detalle` INT, IN `negocio` INT, IN `lector` INT)  NO SQL
BEGIN
IF negocio=1 THEN

SELECT d.tiempo_total_por_proceso,d.cantidad_terminada FROM detalle_formato_estandar d WHERE d.detalle_proyecto_idDetalle_proyecto=detalle AND d.Procesos_idproceso=lector AND d.estado_idestado=3;

ELSE
 IF negocio=2 THEN

SELECT d.tiempo_total_proceso,d.cantidad_terminada FROM detalle_teclados d WHERE d.detalle_proyecto_idDetalle_proyecto=detalle AND d.Procesos_idproceso=lector AND d.estado_idestado=3;

 ELSE
  
 SELECT d.tiempo_total_por_proceso,d.cantidad_terminada FROM detalle_ensamble d WHERE d.detalle_proyecto_idDetalle_proyecto=detalle AND d.Procesos_idproceso=lector AND d.estado_idestado=3;
 
 END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ProyectosEnEjecucion` (IN `negocio` INT)  NO SQL
BEGIN

IF negocio=1 THEN

SELECT d.proyecto_numero_orden FROM detalle_formato_estandar f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto WHERE f.estado_idestado=4 GROUP BY d.proyecto_numero_orden;


else
 IF negocio=2 THEN

SELECT d.proyecto_numero_orden FROM detalle_teclados f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto WHERE f.estado_idestado=4 GROUP BY d.proyecto_numero_orden;

 ELSE
  IF negocio=3 THEN

SELECT d.proyecto_numero_orden FROM detalle_ensamble f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto WHERE f.estado_idestado=4 GROUP BY d.proyecto_numero_orden;

  END IF;
 END IF;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ReactivarProyecto` (IN `orden` INT)  NO SQL
BEGIN

UPDATE proyecto p SET p.eliminacion=1 WHERE p.numero_orden=orden;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_RecuperaContraseñaUser` (IN `rec` VARCHAR(10))  NO SQL
BEGIN

IF EXISTS(SELECT u.numero_documento FROM usuario u WHERE u.recuperacion=rec) THEN

SELECT u.numero_documento,u.contraeña FROM usuario u WHERE u.recuperacion=rec;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_RegistrarDetalleAlmacen` (IN `orden` INT, IN `tipo` INT, IN `proceso` INT)  NO SQL
BEGIN
DECLARE detalle int;
DECLARE cantidad int;

set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.tipo_negocio_idtipo_negocio=tipo AND dd.negocio_idnegocio=4));

INSERT INTO `almacen`(`tiempo_total_proceso`, `cantidad_recibida`, `fecha_inicio`,`detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`, `hora_registro`) VALUES ('0','0',now(),detalle,proceso,4,CURRENT_TIME);

SET cantidad= (SELECT COUNT(*) FROM almacen a WHERE  a.detalle_proyecto_idDetalle_proyecto=detalle AND a.estado_idestado=4);


UPDATE detalle_proyecto d SET d.pro_Ejecucion=cantidad WHERE idDetalle_proyecto=detalle;

CALL PA_CambiarEstadoDeProductos(4,detalle);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_RegistrarDetalleEnsamble` (IN `orden` INT, IN `tipo` INT, IN `ubic` VARCHAR(25), IN `proceso` INT)  NO SQL
BEGIN

DECLARE detalle int;

IF ubic='' THEN
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.tipo_negocio_idtipo_negocio=tipo AND dd.negocio_idnegocio=3 AND dd.ubicacion is null));

ELSE
 
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.tipo_negocio_idtipo_negocio=tipo AND dd.negocio_idnegocio=3 AND dd.ubicacion=ubic));

END IF;

INSERT INTO `detalle_ensamble`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES ('00:00','00:00','0',detalle,proceso,1);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_RegistrarDetalleFormatoEstandar` (IN `orden` INT, IN `tipo` INT, IN `ubic` VARCHAR(25))  NO SQL
BEGIN
DECLARE material varchar(3);
DECLARE antisolder int;
declare ruteo int;
declare detalle int;

 IF ubic='' THEN
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.tipo_negocio_idtipo_negocio=tipo AND dd.negocio_idnegocio=1 AND dd.ubicacion is null));

 ELSE
 
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.tipo_negocio_idtipo_negocio=tipo AND dd.negocio_idnegocio=1 AND dd.ubicacion=ubic));

 END IF;



IF tipo=2 THEN
INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,1,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,3,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,4,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,5,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,7,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,8,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,9,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,10,1);
ELSE
IF tipo=3 or tipo=4 THEN
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,1,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,4,1);
ELSE
   IF tipo=6 THEN
#Perforado
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,1,1);
#Caminos
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,3,1);
#Quemado
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,4,1);
ELSE
     IF tipo=1 or tipo=7 THEN
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,1,1);


set material=(SELECT d.material from detalle_proyecto d WHERE d.proyecto_numero_orden=(orden) AND d.idDetalle_proyecto=detalle);


IF material="TH" THEN
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,2,1);
END IF;


 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,3,1);

 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,4,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,5,1);

     IF tipo=1 THEN
set antisolder=(SELECT antisolderC from proyecto where numero_orden=(SELECT proyecto_numero_orden from detalle_proyecto WHERE idDetalle_proyecto=detalle));

set ruteo=(SELECT ruteoC from proyecto where numero_orden=(SELECT proyecto_numero_orden from detalle_proyecto WHERE idDetalle_proyecto=detalle));

 IF antisolder=1 THEN
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,6,1);
 END IF;
 
INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,7,1);

 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,8,1);

  IF ruteo=1 THEN
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,9,1);
 END IF;
     END IF;
          IF tipo=7 THEN
          
set antisolder=(SELECT antisolderP from proyecto where numero_orden=(SELECT proyecto_numero_orden from detalle_proyecto WHERE idDetalle_proyecto=detalle));

set ruteo=(SELECT ruteoP from proyecto where numero_orden=(SELECT proyecto_numero_orden from detalle_proyecto WHERE idDetalle_proyecto=detalle));
 IF antisolder=1 THEN
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,6,1);
 END IF;
INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,7,1);

 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,8,1);

  IF ruteo=1 THEN
INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,9,1);
 END IF;
          END IF;
INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,10,1);
   END IF;
  END IF;
 END IF;
END IF;

SET tipo= (SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=detalle AND d.estado_idestado=1);


UPDATE detalle_proyecto SET pro_porIniciar=tipo WHERE idDetalle_proyecto=detalle;

CALL PA_CambiarEstadoDeProductos(1,detalle);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_RegistrarDetalleProyectoQR` (IN `orden` INT, IN `area` INT, IN `producto` INT, IN `cantidad` VARCHAR(25), IN `material` VARCHAR(25), IN `ruteo` INT, IN `antisolder` INT)  NO SQL
BEGIN

IF producto=1 AND area=1 THEN
UPDATE proyecto p SET p.FE=1,p.pcb_FE=1,p.antisolderC=antisolder,p.ruteoC=ruteo WHERE p.numero_orden=orden;
ELSE
 IF producto=1 AND area=3 THEN
  UPDATE proyecto p SET p.IN=1 WHERE p.numero_orden=orden;
 ELSE
  IF producto=5 THEN
    UPDATE proyecto p SET p.TE=1 WHERE p.numero_orden=orden;
  ELSE
   IF producto=2 THEN
   	   UPDATE proyecto p SET p.TE=1,p.FE=1,p.Conversor=1 WHERE p.numero_orden=orden;
   ELSE 
    IF producto=3 THEN
         UPDATE proyecto p SET p.TE=1,p.FE=1,p.Repujado=1 WHERE p.numero_orden=orden;
    ELSE
     IF producto=4 THEN
           UPDATE proyecto p SET p.TE=1,p.FE=1,p.troquel=1 WHERE p.numero_orden=orden;
     ELSE
      IF producto=6 THEN
              UPDATE proyecto p SET p.FE=1,p.IN=1,p.stencil=1 WHERE p.numero_orden=orden;
       ELSE
        IF producto=7 THEN
                 UPDATE proyecto p SET p.FE=1,p.TE=1,p.pcb_TE=1,p.antisolderP=antisolder,p.ruteoP=ruteo WHERE p.numero_orden=orden;
        END IF;
      END IF;
     END IF;
    END IF;
   END IF;
  END IF;
 END IF;
END IF;
IF material != '' THEN
INSERT INTO `detalle_proyecto`(`tipo_negocio_idtipo_negocio`, `canitadad_total`, `proyecto_numero_orden`, `negocio_idnegocio`, `estado_idestado`,`material`,`PNC`) VALUES (producto,cantidad,orden,area,1,material,0);
SELECT 1;
ELSE
INSERT INTO `detalle_proyecto`(`tipo_negocio_idtipo_negocio`, `canitadad_total`, `proyecto_numero_orden`, `negocio_idnegocio`, `estado_idestado`,`PNC`) VALUES (producto,cantidad,orden,area,1,0);
SELECT 1;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_RegistrarDetalleTeclados` (IN `orden` INT, IN `tipo` INT, IN `ubic` VARCHAR(25), IN `proceso` INT)  NO SQL
BEGIN

DECLARE detalle int;

IF ubic='' THEN
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.tipo_negocio_idtipo_negocio=tipo AND dd.negocio_idnegocio=2 AND dd.ubicacion is null));

ELSE
 
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.tipo_negocio_idtipo_negocio=tipo AND dd.negocio_idnegocio=2 AND dd.ubicacion=ubic));

END IF;

INSERT INTO `detalle_teclados`(`tiempo_por_unidad`, `tiempo_total_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`)VALUES
('00:00','00:00','0',detalle,proceso,1);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_RegistrarModificarPuertoSerialUsuario` (IN `documento` VARCHAR(13), IN `com` VARCHAR(6))  NO SQL
BEGIN

IF (EXISTS(SELECT * FROM usuariopuerto up WHERE up.documentousario=documento)) THEN
#Modificar

UPDATE usuariopuerto up SET up.usuarioPuerto=com WHERE up.documentousario=documento;

ELSE
#registrar

INSERT INTO usuariopuerto VALUES (documento,com);

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ReporteGeneral` ()  NO SQL
BEGIN

SELECT p.numero_orden,p.nombre_cliente,p.nombre_proyecto,dp.canitadad_total,n.nom_negocio,t.nombre,dp.Total_timepo_Unidad,dp.tiempo_total FROM detalle_proyecto dp JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden JOIN negocio n on dp.negocio_idnegocio=n.idnegocio JOIN tipo_negocio t ON dp.tipo_negocio_idtipo_negocio=t.idtipo_negocio;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_Sesion` (IN `sec` INT, IN `ced` VARCHAR(13))  NO SQL
BEGIN

UPDATE usuario u SET u.sesion=sec WHERE u.numero_documento=ced;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_TiempoProceso` (IN `detalle` INT, IN `negocio` INT)  NO SQL
BEGIN

IF negocio=1 THEN
SELECT df.tiempo_total_por_proceso FROM detalle_formato_estandar df WHERE df.detalle_proyecto_idDetalle_proyecto=detalle AND df.estado_idestado!=1;

ELSE
 IF negocio=2 THEN
  SELECT dt.tiempo_total_proceso FROM detalle_teclados dt WHERE dt.detalle_proyecto_idDetalle_proyecto=detalle AND dt.estado_idestado!=1;
 ELSE
  SELECT de.tiempo_total_por_proceso FROM detalle_ensamble de WHERE de.detalle_proyecto_idDetalle_proyecto=detalle AND de.estado_idestado!=1;
 END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_TodosLosDetallesEnEjecucion` (IN `orden` INT)  NO SQL
BEGIN
SELECT dp.idDetalle_proyecto,dp.negocio_idnegocio FROM detalle_proyecto dp WHERE dp.proyecto_numero_orden=orden AND dp.estado_idestado=4;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ValidarCantidadDetalleProyecto` (IN `orden` INT, IN `detalle` INT, IN `lector` INT, IN `busqueda` INT)  NO SQL
BEGIN

DECLARE can int;
DECLARE id int;
DECLARE oper int;

IF busqueda=1 THEN

SET id=(SELECT f.cantidad_terminada from detalle_formato_estandar f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
SET oper=(SELECT f.noperarios FROM detalle_formato_estandar f WHERE f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=lector);

ELSE
 IF busqueda=2 THEN
 
 SET id=(SELECT f.cantidad_terminada from detalle_teclados f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
  SET oper=(SELECT f.noperarios FROM detalle_teclados f WHERE f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=lector);
 ELSE
  IF busqueda=3 THEN
  
  SET id=(SELECT f.cantidad_terminada from detalle_ensamble f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
    SET oper=(SELECT f.noperarios FROM detalle_ensamble f WHERE f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=lector);
  ELSE
   SET id=(SELECT f.cantidad_recibida from almacen f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
  END IF; 
 END IF;
END IF;

set can=(select d.canitadad_total FROM detalle_proyecto d WHERE d.idDetalle_proyecto=detalle);

SELECT can as contidad_total,id as cantidad_proceso,oper as operarios;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ValidarCantidadPNCOrigen` (IN `orden` INT, IN `detalle` INT, IN `op` INT, IN `tipo` INT, IN `negocio` INT)  NO SQL
BEGIN

IF op=1 THEN

 SELECT d.canitadad_total FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden and d.idDetalle_proyecto=detalle;

else

SELECT d.canitadad_total FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden and d.PNC=0 and d.negocio_idnegocio=negocio AND d.tipo_negocio_idtipo_negocio=tipo;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ValidarDetalleProyectoQR` (IN `orden` INT, IN `area` INT, IN `producto` INT)  NO SQL
BEGIN

IF EXISTS(SELECT * FROM detalle_proyecto dp WHERE dp.proyecto_numero_orden=orden AND dp.negocio_idnegocio=area AND dp.tipo_negocio_idtipo_negocio=producto) THEN
SELECT 0;
ELSE
SELECT 1;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ValidarEstadoProyecto` (IN `detalle` INT, IN `negocio` INT)  NO SQL
BEGIN

IF EXISTS(SELECT * FROM detalle_proyecto dp WHERE dp.estado_idestado=3 AND dp.idDetalle_proyecto=detalle)  THEN

 IF negocio=1 THEN
    SELECT df.tiempo_por_unidad FROM detalle_formato_estandar df WHERE df.detalle_proyecto_idDetalle_proyecto=detalle AND df.tiempo_por_unidad!='00:00';
 ELSE
  IF negocio=2 THEN
      SELECT df.tiempo_por_unidad FROM detalle_teclados df WHERE df.detalle_proyecto_idDetalle_proyecto=detalle AND df.tiempo_por_unidad!='00:00';
   ELSE
      SELECT df.tiempo_por_unidad FROM detalle_ensamble df WHERE df.detalle_proyecto_idDetalle_proyecto=detalle AND df.tiempo_por_unidad!='00:00';
  END IF;
 END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_validarPNC` (IN `orden` INT, IN `proceso` VARCHAR(30))  NO SQL
BEGIN

SELECT p.idDetalle_proyecto FROM detalle_proyecto p WHERE p.ubicacion=proceso and p.proyecto_numero_orden=orden;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ValidarProyectoQR` (IN `orden` INT)  NO SQL
BEGIN

IF EXISTS(SELECT * FROM proyecto p WHERE p.numero_orden=orden) THEN
SELECT 0;
ELSE
SELECT 1;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ValidarUbicacionPNC` (IN `orden` INT, IN `ubicacion` VARCHAR(50), IN `detalle` INT)  NO SQL
BEGIN

IF EXISTS(SELECT * FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden AND d.PNC=1 and d.ubicacion=ubicacion AND d.idDetalle_proyecto=detalle) THEN
SELECT d.idDetalle_proyecto FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden AND d.PNC=1 and d.ubicacion=ubicacion AND d.idDetalle_proyecto=detalle;

ELSE

SELECT 0;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pruebas` (IN `nov` INT(250))  NO SQL
BEGIN

IF nov='' THEN

SELECT 'Hola mundo';

END IF;

END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ActualizarEstado` (`doc` VARCHAR(13), `est` BOOLEAN) RETURNS TINYINT(1) NO SQL
BEGIN
DECLARE val varchar(13);
set val= (SELECT numero_documento from usuario where numero_documento=doc);

IF val=doc THEN
UPDATE usuario SET estado=est WHERE numero_documento=doc;
RETURN 1;
ELSE
RETURN 0;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_CambiarContraseña` (`doc` VARCHAR(13), `contra` VARCHAR(20), `anti` VARCHAR(20)) RETURNS TINYINT(1) NO SQL
BEGIN
DECLARE var varchar(20);
set var=(SELECT u.contraeña FROM usuario u WHERE u.numero_documento = doc);
IF var=anti THEN
UPDATE usuario u SET u.contraeña=contra WHERE u.numero_documento=doc;
RETURN 1;
ELSE
RETURN 0;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_CambiarEstadoProcesos` (`id` INT, `estado` INT) RETURNS TINYINT(1) NO SQL
BEGIN

UPDATE procesos p SET p.estado=estado WHERE p.idproceso=id;
RETURN 1;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_EliminarDetalleProyectoAlmacen` (`iddetalle` INT, `orden` INT) RETURNS INT(11) NO SQL
BEGIN

DELETE FROM almacen WHERE detalle_proyecto_idDetalle_proyecto=iddetalle;

DELETE FROM `detalle_proyecto` WHERE idDetalle_proyecto=iddetalle;
 
CALL PA_CambiarEstadoDeProyecto(orden);

RETURN 1;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_EliminarDetalleProyectoEnsamble` (`iddetalle` INT, `orden` INT) RETURNS TINYINT(1) NO SQL
BEGIN
DECLARE cantidad int;
SET cantidad=(SELECT count(*) from detalle_ensamble f INNER JOIN detalle_proyecto d  WHERE f.detalle_proyecto_idDetalle_proyecto=iddetalle AND f.fecha_inicio is not null and d.proyecto_numero_orden=orden);

IF cantidad=0 THEN
DELETE FROM `detalle_ensamble` WHERE detalle_proyecto_idDetalle_proyecto=iddetalle;

DELETE FROM `detalle_proyecto` WHERE idDetalle_proyecto=iddetalle;
CALL PA_CambiarEstadoDeProyecto(orden);
RETURN 1;
ELSE
RETURN 0;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_EliminarDetalleProyectoFormatoestandar` (`iddetalle` INT, `orden` INT) RETURNS TINYINT(1) NO SQL
BEGIN
DECLARE cantidad int;
SET cantidad=(SELECT count(*) from detalle_formato_estandar f INNER JOIN detalle_proyecto d  WHERE f.detalle_proyecto_idDetalle_proyecto=iddetalle AND f.fecha_inicio is not null and d.proyecto_numero_orden=orden);

IF cantidad=0 THEN
DELETE FROM `detalle_formato_estandar` WHERE detalle_proyecto_idDetalle_proyecto=iddetalle;

DELETE FROM `detalle_proyecto` WHERE idDetalle_proyecto=iddetalle;
CALL PA_CambiarEstadoDeProyecto(orden);
RETURN 1;
ELSE
RETURN 0;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_EliminarDetalleProyectoTeclados` (`iddetalle` INT, `orden` INT) RETURNS TINYINT(1) NO SQL
BEGIN
DECLARE cantidad int;
SET cantidad=(SELECT count(*) from detalle_teclados f INNER JOIN detalle_proyecto d  WHERE f.detalle_proyecto_idDetalle_proyecto=iddetalle AND f.fecha_inicio is not null and d.proyecto_numero_orden=orden);

IF cantidad=0 THEN
DELETE FROM `detalle_teclados` WHERE detalle_proyecto_idDetalle_proyecto=iddetalle;

DELETE FROM `detalle_proyecto` WHERE idDetalle_proyecto=iddetalle;
CALL PA_CambiarEstadoDeProyecto(orden);
RETURN 1;
ELSE
RETURN 0;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_EstadoDeProyecto` (`orden` INT) RETURNS TINYINT(1) NO SQL
BEGIN

IF EXISTS(SELECT * FROM proyecto p WHERE p.numero_orden=orden
         AND p.estado_idestado!=4) THEN
         RETURN 1;

ELSE
	RETURN 0;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_IniciarSesion` (`usuario` VARCHAR(13), `pasw` VARCHAR(20)) RETURNS TINYINT(2) NO SQL
BEGIN
DECLARE val varchar(13);
DECLARE car int;
SET val=(SELECT u.numero_documento from usuario u WHERE u.numero_documento=usuario AND u.contraeña= pasw AND estado=1);
if val!='' THEN
set car=(SELECT cargo_idcargo FROM usuario WHERE numero_documento = usuario);
  RETURN car;
ELSE
  RETURN 0;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_InsertarModificarUsuar` (`_doc` VARCHAR(13), `_tipo` VARCHAR(3), `_nombre` VARCHAR(30), `_apellido` VARCHAR(30), `_cargo` TINYINT, `_estado` TINYINT, `op` TINYINT, `rec` VARCHAR(10)) RETURNS TINYINT(1) READS SQL DATA
BEGIN
 DECLARE val varchar(13);
if op=1 THEN
SET val=(SELECT numero_documento FROM usuario WHERE    numero_documento=_doc);
  IF val=_doc THEN
     RETURN 0;
 ELSE 
     INSERT INTO        usuario(numero_documento,tipo_documento,nombres,apellidos,cargo_idcargo,estado,contraeña,recuperacion)   VALUES (_doc,_tipo,_nombre,_apellido,_cargo,_estado,_doc,rec);
  return 1;
  
END IF;
ELSE
UPDATE usuario SET tipo_documento=_tipo,nombres=_nombre, apellidos=_apellido, cargo_idcargo=_cargo,estado=_estado where  numero_documento=_doc;
RETURN 1;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ModificarDetalleProyecto` (`orden` INT, `idDetalle` INT, `cantidad` VARCHAR(6), `material` VARCHAR(6), `negocio` INT, `ubicacion` VARCHAR(25)) RETURNS TINYINT(1) NO SQL
BEGIN
UPDATE detalle_proyecto dp SET dp.canitadad_total=cantidad,dp.material=material,dp.ubicacion=ubicacion WHERE idDetalle_proyecto=idDetalle and proyecto_numero_orden=orden;
CALL PA_CambiarEstadoDeProductos(negocio,idDetalle);
RETURN 1;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_RegistrarDetalleProyecto` (`orden` INT(11), `tipoNegocio` VARCHAR(20), `cantidad` VARCHAR(6), `negocio` VARCHAR(20), `estado` TINYINT(1), `material` VARCHAR(6), `pnc` TINYINT(1), `ubic` VARCHAR(30)) RETURNS TINYINT(1) NO SQL
BEGIN
IF material != '' THEN
INSERT INTO `detalle_proyecto`(`tipo_negocio_idtipo_negocio`, `canitadad_total`, `proyecto_numero_orden`, `negocio_idnegocio`, `estado_idestado`,`material`,`PNC`,`ubicacion`) VALUES ((SELECT idtipo_negocio from tipo_negocio where nombre =tipoNegocio),cantidad,orden,(SELECT idnegocio FROM negocio WHERE nom_negocio =negocio),estado,material,pnc,ubic);
RETURN 1;
ELSE
INSERT INTO `detalle_proyecto`(`tipo_negocio_idtipo_negocio`, `canitadad_total`, `proyecto_numero_orden`, `negocio_idnegocio`, `estado_idestado`,`PNC`,`ubicacion`) VALUES ((SELECT idtipo_negocio from tipo_negocio where nombre =tipoNegocio),cantidad,orden,(SELECT idnegocio FROM negocio WHERE nom_negocio =negocio),estado,pnc,ubic);
RETURN 1;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_RegistrarModificarProcesos` (`op` INT, `nombre` VARCHAR(30), `area` INT, `id` INT) RETURNS TINYINT(1) NO SQL
BEGIN

IF op=1 THEN
INSERT INTO `procesos`(`nombre_proceso`, `estado`, `negocio_idnegocio`) VALUES (nombre,1,area);
RETURN 1;
else
UPDATE procesos p SET p.nombre_proceso=nombre,p.negocio_idnegocio=area WHERE p.idproceso=id;
RETURN 1;
END IF;


END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_RegistrarModificarProyecto` (`doc` VARCHAR(13), `cliente` VARCHAR(150), `proyecto` VARCHAR(150), `tipo` VARCHAR(6), `fe` TINYINT(1), `te` TINYINT(1), `inte` TINYINT(1), `pcbfe` TINYINT(1), `pcbte` TINYINT(1), `conv` TINYINT(1), `rep` TINYINT(1), `tro` TINYINT(1), `st` TINYINT(1), `lexan` TINYINT(1), `entrega` VARCHAR(11), `ruteo` TINYINT(1), `anti` TINYINT(1), `norden` INT, `op` TINYINT(1), `ruteoP` TINYINT(1), `antiP` TINYINT(1), `fecha1` VARCHAR(11), `fecha2` VARCHAR(11), `fecha3` VARCHAR(11), `fecha4` VARCHAR(11), `novedad` VARCHAR(250), `estadopro` VARCHAR(13), `nfee` VARCHAR(11)) RETURNS TINYINT(11) NO SQL
BEGIN
DECLARE nov varchar(250);

IF novedad='' THEN
 SET nov='';
ELSE 
 SET nov=novedad;
END IF;

IF op=1 THEN

INSERT INTO `proyecto`(`numero_orden`,`usuario_numero_documento`, `nombre_cliente`, `nombre_proyecto`, `tipo_proyecto`, `FE`, `TE`, `IN`, `pcb_FE`, `pcb_TE`, `Conversor`, `Repujado`, `troquel`, `stencil`, `lexan`, `fecha_ingreso`, `fecha_entrega`, `ruteoC`, `antisolderC`, `estado_idestado`,`ruteoP`,`antisolderP`,`entregaCircuitoFEoGF`,`entregaCOMCircuito`,`entregaPCBFEoGF`,`entregaPCBCom`) VALUES (norden,doc,cliente,proyecto,tipo,fe,te,inte,pcbfe,pcbte,conv,rep,tro,st,lexan,(SELECT now()),entrega,ruteo,anti,1,ruteoP,antiP,fecha1,fecha2,fecha3,fecha4); 
RETURN 1;
ELSE 
 UPDATE `proyecto` SET `nombre_cliente`=cliente,`nombre_proyecto`=proyecto,`tipo_proyecto`=tipo,`FE`=fe,`TE`=te,`IN`=inte,`pcb_FE`=pcbfe,`pcb_TE`=pcbte,`Conversor`=conv,`Repujado`=rep,`troquel`=tro,`stencil`=st,`lexan`=lexan,`fecha_entrega`=entrega,`ruteoC`=ruteo,`antisolderC`=anti,`ruteoP`=ruteoP,`antisolderP`=antiP,`entregaCircuitoFEoGF`=fecha1,`entregaCOMCircuito`=fecha2,`entregaPCBFEoGF`=fecha3,`entregaPCBCom`=fecha4,`novedades`=nov,`estadoEmpresa`=estadopro,`NFEE`=nfee WHERE numero_orden=norden;
RETURN 1;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ReiniciarTiempo` (`detalle` INT, `negocio` INT) RETURNS TINYINT(1) NO SQL
BEGIN
DECLARE cantidadp int;
DECLARE detalleN int;


IF negocio=1 THEN
UPDATE `detalle_formato_estandar` SET `tiempo_por_unidad`= "00:00",`tiempo_total_por_proceso`="00:00",`cantidad_terminada`=0,`fecha_inicio`=null,`fecha_fin`=null,`estado_idestado`=1,`hora_ejecucion`=null,`hora_terminacion`=null,restantes=0 WHERE `idDetalle_formato_estandar`=detalle;
SET detalleN =(SELECT d.detalle_proyecto_idDetalle_proyecto FROM detalle_formato_estandar d WHERE d.idDetalle_formato_estandar=detalle);

 SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalleN) AND d.estado_idestado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalleN) AND d.estado_idestado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalleN) AND d.estado_idestado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalleN) AND d.estado_idestado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalleN;
CALL PA_CambiarEstadoDeProductos(negocio,detalleN);
  RETURN 1;
ELSE
 IF negocio=2 THEN
 UPDATE `detalle_teclados` SET `tiempo_por_unidad`= "00:00",`tiempo_total_proceso`="00:00",`cantidad_terminada`=0,`fecha_inicio`=null,`fecha_fin`=null,`estado_idestado`=1,`hora_ejecucion`=null,`hora_terminacion`=null,restantes=0 WHERE `idDetalle_teclados`=detalle;
SET detalleN =(SELECT d.detalle_proyecto_idDetalle_proyecto FROM detalle_teclados d WHERE d.idDetalle_teclados=detalle);

 SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalleN) AND d.estado_idestado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalleN) AND d.estado_idestado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalleN) AND d.estado_idestado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalleN) AND d.estado_idestado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalleN;
CALL PA_CambiarEstadoDeProductos(negocio,detalleN);
 RETURN 1;
 ELSE
  UPDATE `detalle_ensamble` SET `tiempo_por_unidad`= "00:00",`tiempo_total_por_proceso`="00:00",`cantidad_terminada`=0,`fecha_inicio`=null,`fecha_fin`=null,`estado_idestado`=1,`hora_ejecucion`=null,`hora_terminacion`=null,restantes=0 WHERE `idDetalle_ensamble`=detalle;
SET detalleN =(SELECT d.detalle_proyecto_idDetalle_proyecto FROM detalle_ensamble d WHERE d.idDetalle_ensamble=detalle);

 SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalleN) AND d.estado_idestado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalleN) AND d.estado_idestado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalleN) AND d.estado_idestado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalleN) AND d.estado_idestado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalleN;

CALL PA_CambiarEstadoDeProductos(negocio,detalleN);
  RETURN 1;
 END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_validarActividad` (`doc` VARCHAR(13)) RETURNS INT(11) NO SQL
BEGIN

IF EXISTS(SELECT u.numero_documento from usuario u WHERE u.numero_documento=doc and u.sesion=1) THEN
RETURN 1;
ELSE
RETURN 0;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_validarEliminacion` (`iddetalle` INT, `orden` INT, `tipo` INT, `busqueda` INT) RETURNS TINYINT(1) NO SQL
BEGIN
DECLARE cantidad int;

IF busqueda=1 THEN
  SET cantidad=(SELECT count(*) from detalle_formato_estandar f INNER JOIN detalle_proyecto d  WHERE f.detalle_proyecto_idDetalle_proyecto=iddetalle AND f.fecha_inicio is not null and d.proyecto_numero_orden=orden);   
IF cantidad=0 THEN
RETURN 1;
ELSE
RETURN 0;
END IF;
 ELSE
 IF busqueda=2 THEN
 SET cantidad=(SELECT count(*) from detalle_teclados f INNER JOIN detalle_proyecto d  WHERE f.detalle_proyecto_idDetalle_proyecto=iddetalle AND f.fecha_inicio is not null and d.proyecto_numero_orden=orden);
IF cantidad=0 THEN
RETURN 1;
ELSE
RETURN 0;
END IF;
  ELSE
  IF busqueda=3 THEN
    SET cantidad=(SELECT count(*) from detalle_ensamble f INNER JOIN detalle_proyecto d  WHERE f.detalle_proyecto_idDetalle_proyecto=iddetalle AND f.fecha_inicio is not null and d.proyecto_numero_orden=orden);

IF cantidad=0 THEN
RETURN 1;
ELSE
RETURN 0;
END IF;
    END IF;
 END if;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ValidarEstadoEliminado` (`orden` INT) RETURNS TINYINT(1) NO SQL
BEGIN

IF EXISTS(SELECT * FROM proyecto p WHERE p.numero_orden=orden AND p.eliminacion=1) THEN
RETURN 1;
ELSE
RETURN 0;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ValidarEstadoProyectoEjecucionOParada` (`orden` INT) RETURNS TINYINT(1) NO SQL
BEGIN

IF EXISTS(SELECT * FROM proyecto p WHERE p.numero_orden=orden AND p.parada=1) THEN
RETURN 1;
ELSE
return 0;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ValidarNumerOrden` (`orden` INT) RETURNS TINYINT(1) NO SQL
BEGIN

IF EXISTS(SELECT * FROM proyecto d WHERE d.numero_orden=orden) THEN
RETURN 1;
ELSE
RETURN 0;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ValidarTomaDeTiempo` (`orden` INT, `detalle` INT, `lector` INT, `busqueda` INT) RETURNS TINYINT(1) NO SQL
BEGIN

DECLARE id int;

IF busqueda=1 THEN
SET id=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
ELSE
  IF busqueda=2 THEN
SET id=(SELECT f.idDetalle_teclados from 
detalle_teclados f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
  ELSE 
    IF busqueda=3 THEN
    SET id=(SELECT f.idDetalle_ensamble from 
detalle_ensamble f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
    END IF;
  END IF;
END IF;

IF id !='null' THEN
RETURN 1;
ELSE
RETURN 0;
END IF;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `almacen`
--

CREATE TABLE `almacen` (
  `idalmacen` smallint(6) NOT NULL,
  `tiempo_total_proceso` varchar(20) DEFAULT NULL,
  `cantidad_recibida` varchar(7) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `detalle_proyecto_idDetalle_proyecto` int(11) NOT NULL,
  `Procesos_idproceso` tinyint(4) NOT NULL,
  `estado_idestado` tinyint(4) NOT NULL,
  `hora_registro` time DEFAULT NULL,
  `hora_llegada` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cargo`
--

CREATE TABLE `cargo` (
  `idcargo` tinyint(4) NOT NULL,
  `nombre` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `cargo`
--

INSERT INTO `cargo` (`idcargo`, `nombre`) VALUES
(1, 'Gestor Comercial'),
(2, 'Encargado de FE y TE'),
(3, 'Encargado de EN'),
(4, 'Administrador'),
(5, 'Almacen');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_ensamble`
--

CREATE TABLE `detalle_ensamble` (
  `idDetalle_ensamble` smallint(6) NOT NULL,
  `tiempo_por_unidad` varchar(6) DEFAULT NULL,
  `tiempo_total_por_proceso` varchar(10) DEFAULT '00:00',
  `cantidad_terminada` varchar(6) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `detalle_proyecto_idDetalle_proyecto` int(11) NOT NULL,
  `Procesos_idproceso` tinyint(4) NOT NULL,
  `estado_idestado` tinyint(4) NOT NULL,
  `hora_ejecucion` time DEFAULT NULL,
  `hora_terminacion` time DEFAULT NULL,
  `restantes` int(6) NOT NULL DEFAULT '0',
  `noperarios` tinyint(2) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_formato_estandar`
--

CREATE TABLE `detalle_formato_estandar` (
  `idDetalle_formato_estandar` smallint(6) NOT NULL,
  `tiempo_por_unidad` varchar(6) DEFAULT NULL,
  `tiempo_total_por_proceso` varchar(10) DEFAULT '00:00',
  `cantidad_terminada` varchar(6) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `detalle_proyecto_idDetalle_proyecto` int(11) NOT NULL,
  `Procesos_idproceso` tinyint(4) NOT NULL,
  `estado_idestado` tinyint(4) NOT NULL,
  `hora_ejecucion` time DEFAULT NULL,
  `hora_terminacion` time DEFAULT NULL,
  `restantes` int(6) NOT NULL DEFAULT '0',
  `noperarios` tinyint(2) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `detalle_formato_estandar`
--

INSERT INTO `detalle_formato_estandar` (`idDetalle_formato_estandar`, `tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `fecha_inicio`, `fecha_fin`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`, `hora_ejecucion`, `hora_terminacion`, `restantes`, `noperarios`) VALUES
(1, '00:00', '00:00', '0', NULL, NULL, 716, 1, 1, NULL, NULL, 0, 0),
(2, '00:00', '00:00', '0', NULL, NULL, 716, 3, 1, NULL, NULL, 0, 0),
(3, '00:00', '00:00', '0', NULL, NULL, 716, 4, 1, NULL, NULL, 0, 0),
(4, '00:00', '00:00', '0', NULL, NULL, 716, 5, 1, NULL, NULL, 0, 0),
(5, '00:00', '00:00', '0', NULL, NULL, 716, 6, 1, NULL, NULL, 0, 0),
(6, '00:00', '00:00', '0', NULL, NULL, 716, 7, 1, NULL, NULL, 0, 0),
(7, '00:00', '00:00', '0', NULL, NULL, 716, 8, 1, NULL, NULL, 0, 0),
(8, '00:00', '00:00', '0', NULL, NULL, 716, 9, 1, NULL, NULL, 0, 0),
(9, '00:00', '00:00', '0', NULL, NULL, 716, 10, 1, NULL, NULL, 0, 0),
(10, '00:00', '00:00', '0', NULL, NULL, 717, 1, 1, NULL, NULL, 0, 0),
(11, '00:00', '00:00', '0', NULL, NULL, 717, 3, 1, NULL, NULL, 0, 0),
(12, '00:00', '00:00', '0', NULL, NULL, 717, 4, 1, NULL, NULL, 0, 0),
(13, '00:00', '00:00', '0', NULL, NULL, 717, 5, 1, NULL, NULL, 0, 0),
(14, '00:00', '00:00', '0', NULL, NULL, 717, 6, 1, NULL, NULL, 0, 0),
(15, '00:00', '00:00', '0', NULL, NULL, 717, 7, 1, NULL, NULL, 0, 0),
(16, '00:00', '00:00', '0', NULL, NULL, 717, 8, 1, NULL, NULL, 0, 0),
(17, '00:00', '00:00', '0', NULL, NULL, 717, 9, 1, NULL, NULL, 0, 0),
(18, '00:00', '00:00', '0', NULL, NULL, 717, 10, 1, NULL, NULL, 0, 0),
(19, '00:00', '00:00', '0', NULL, NULL, 718, 1, 1, NULL, NULL, 0, 0),
(20, '00:00', '00:00', '0', NULL, NULL, 718, 2, 1, NULL, NULL, 0, 0),
(21, '00:00', '00:00', '0', NULL, NULL, 718, 3, 1, NULL, NULL, 0, 0),
(22, '00:00', '00:00', '0', NULL, NULL, 718, 4, 1, NULL, NULL, 0, 0),
(23, '00:00', '00:00', '0', NULL, NULL, 718, 5, 1, NULL, NULL, 0, 0),
(24, '00:00', '00:00', '0', NULL, NULL, 718, 6, 1, NULL, NULL, 0, 0),
(25, '00:00', '00:00', '0', NULL, NULL, 718, 7, 1, NULL, NULL, 0, 0),
(26, '00:00', '00:00', '0', NULL, NULL, 718, 8, 1, NULL, NULL, 0, 0),
(27, '00:00', '00:00', '0', NULL, NULL, 718, 9, 1, NULL, NULL, 0, 0),
(28, '00:00', '00:00', '0', NULL, NULL, 718, 10, 1, NULL, NULL, 0, 0),
(29, '00:00', '00:00', '0', NULL, NULL, 719, 1, 1, NULL, NULL, 0, 0),
(30, '00:00', '00:00', '0', NULL, NULL, 719, 2, 1, NULL, NULL, 0, 0),
(31, '00:00', '00:00', '0', NULL, NULL, 719, 3, 1, NULL, NULL, 0, 0),
(32, '00:00', '00:00', '0', NULL, NULL, 719, 4, 1, NULL, NULL, 0, 0),
(33, '00:00', '00:00', '0', NULL, NULL, 719, 5, 1, NULL, NULL, 0, 0),
(34, '00:00', '00:00', '0', NULL, NULL, 719, 7, 1, NULL, NULL, 0, 0),
(35, '00:00', '00:00', '0', NULL, NULL, 719, 8, 1, NULL, NULL, 0, 0),
(36, '00:00', '00:00', '0', NULL, NULL, 719, 9, 1, NULL, NULL, 0, 0),
(37, '00:00', '00:00', '0', NULL, NULL, 719, 10, 1, NULL, NULL, 0, 0),
(38, '00:00', '00:00', '0', NULL, NULL, 720, 1, 1, NULL, NULL, 0, 0),
(39, '00:00', '00:00', '0', NULL, NULL, 720, 2, 1, NULL, NULL, 0, 0),
(40, '00:00', '00:00', '0', NULL, NULL, 720, 3, 1, NULL, NULL, 0, 0),
(41, '00:00', '00:00', '0', NULL, NULL, 720, 4, 1, NULL, NULL, 0, 0),
(42, '00:00', '00:00', '0', NULL, NULL, 720, 5, 1, NULL, NULL, 0, 0),
(43, '00:00', '00:00', '0', NULL, NULL, 720, 6, 1, NULL, NULL, 0, 0),
(44, '00:00', '00:00', '0', NULL, NULL, 720, 7, 1, NULL, NULL, 0, 0),
(45, '00:00', '00:00', '0', NULL, NULL, 720, 8, 1, NULL, NULL, 0, 0),
(46, '00:00', '00:00', '0', NULL, NULL, 720, 10, 1, NULL, NULL, 0, 0),
(47, '00:00', '00:00', '0', NULL, NULL, 721, 1, 1, NULL, NULL, 0, 0),
(48, '00:00', '00:00', '0', NULL, NULL, 721, 2, 1, NULL, NULL, 0, 0),
(49, '00:00', '00:00', '0', NULL, NULL, 721, 3, 1, NULL, NULL, 0, 0),
(50, '00:00', '00:00', '0', NULL, NULL, 721, 4, 1, NULL, NULL, 0, 0),
(51, '00:00', '00:00', '0', NULL, NULL, 721, 5, 1, NULL, NULL, 0, 0),
(52, '00:00', '00:00', '0', NULL, NULL, 721, 6, 1, NULL, NULL, 0, 0),
(53, '00:00', '00:00', '0', NULL, NULL, 721, 7, 1, NULL, NULL, 0, 0),
(54, '00:00', '00:00', '0', NULL, NULL, 721, 8, 1, NULL, NULL, 0, 0),
(55, '00:00', '00:00', '0', NULL, NULL, 721, 9, 1, NULL, NULL, 0, 0),
(56, '00:00', '00:00', '0', NULL, NULL, 721, 10, 1, NULL, NULL, 0, 0),
(57, '00:00', '00:00', '0', NULL, NULL, 722, 1, 1, NULL, NULL, 0, 0),
(58, '00:00', '00:00', '0', NULL, NULL, 722, 2, 1, NULL, NULL, 0, 0),
(59, '00:00', '00:00', '0', NULL, NULL, 722, 3, 1, NULL, NULL, 0, 0),
(60, '00:00', '00:00', '0', NULL, NULL, 722, 4, 1, NULL, NULL, 0, 0),
(61, '00:00', '00:00', '0', NULL, NULL, 722, 5, 1, NULL, NULL, 0, 0),
(62, '00:00', '00:00', '0', NULL, NULL, 722, 6, 1, NULL, NULL, 0, 0),
(63, '00:00', '00:00', '0', NULL, NULL, 722, 7, 1, NULL, NULL, 0, 0),
(64, '00:00', '00:00', '0', NULL, NULL, 722, 8, 1, NULL, NULL, 0, 0),
(65, '00:00', '00:00', '0', NULL, NULL, 722, 9, 1, NULL, NULL, 0, 0),
(66, '00:00', '00:00', '0', NULL, NULL, 722, 10, 1, NULL, NULL, 0, 0),
(67, '00:00', '00:00', '0', NULL, NULL, 723, 1, 1, NULL, NULL, 0, 0),
(68, '00:00', '00:00', '0', NULL, NULL, 723, 3, 1, NULL, NULL, 0, 0),
(69, '00:00', '00:00', '0', NULL, NULL, 723, 4, 1, NULL, NULL, 0, 0),
(70, '00:00', '00:00', '0', NULL, NULL, 723, 5, 1, NULL, NULL, 0, 0),
(71, '00:00', '00:00', '0', NULL, NULL, 723, 6, 1, NULL, NULL, 0, 0),
(72, '00:00', '00:00', '0', NULL, NULL, 723, 7, 1, NULL, NULL, 0, 0),
(73, '00:00', '00:00', '0', NULL, NULL, 723, 8, 1, NULL, NULL, 0, 0),
(74, '00:00', '00:00', '0', NULL, NULL, 723, 9, 1, NULL, NULL, 0, 0),
(75, '00:00', '00:00', '0', NULL, NULL, 723, 10, 1, NULL, NULL, 0, 0),
(76, '00:00', '00:00', '0', NULL, NULL, 724, 1, 1, NULL, NULL, 0, 0),
(77, '00:00', '00:00', '0', NULL, NULL, 724, 2, 1, NULL, NULL, 0, 0),
(78, '00:00', '00:00', '0', NULL, NULL, 724, 3, 1, NULL, NULL, 0, 0),
(79, '00:00', '00:00', '0', NULL, NULL, 724, 4, 1, NULL, NULL, 0, 0),
(80, '00:00', '00:00', '0', NULL, NULL, 724, 5, 1, NULL, NULL, 0, 0),
(81, '00:00', '00:00', '0', NULL, NULL, 724, 6, 1, NULL, NULL, 0, 0),
(82, '00:00', '00:00', '0', NULL, NULL, 724, 7, 1, NULL, NULL, 0, 0),
(83, '00:00', '00:00', '0', NULL, NULL, 724, 8, 1, NULL, NULL, 0, 0),
(84, '00:00', '00:00', '0', NULL, NULL, 724, 10, 1, NULL, NULL, 0, 0),
(85, '00:00', '00:00', '0', NULL, NULL, 725, 1, 1, NULL, NULL, 0, 0),
(86, '00:00', '00:00', '0', NULL, NULL, 725, 2, 1, NULL, NULL, 0, 0),
(87, '00:00', '00:00', '0', NULL, NULL, 725, 3, 1, NULL, NULL, 0, 0),
(88, '00:00', '00:00', '0', NULL, NULL, 725, 4, 1, NULL, NULL, 0, 0),
(89, '00:00', '00:00', '0', NULL, NULL, 725, 5, 1, NULL, NULL, 0, 0),
(90, '00:00', '00:00', '0', NULL, NULL, 725, 6, 1, NULL, NULL, 0, 0),
(91, '00:00', '00:00', '0', NULL, NULL, 725, 7, 1, NULL, NULL, 0, 0),
(92, '00:00', '00:00', '0', NULL, NULL, 725, 8, 1, NULL, NULL, 0, 0),
(93, '00:00', '00:00', '0', NULL, NULL, 725, 10, 1, NULL, NULL, 0, 0),
(94, '00:00', '00:00', '0', NULL, NULL, 726, 1, 1, NULL, NULL, 0, 0),
(95, '00:00', '00:00', '0', NULL, NULL, 726, 3, 1, NULL, NULL, 0, 0),
(96, '00:00', '00:00', '0', NULL, NULL, 726, 4, 1, NULL, NULL, 0, 0),
(97, '00:00', '00:00', '0', NULL, NULL, 726, 5, 1, NULL, NULL, 0, 0),
(98, '00:00', '00:00', '0', NULL, NULL, 726, 6, 1, NULL, NULL, 0, 0),
(99, '00:00', '00:00', '0', NULL, NULL, 726, 7, 1, NULL, NULL, 0, 0),
(100, '00:00', '00:00', '0', NULL, NULL, 726, 8, 1, NULL, NULL, 0, 0),
(101, '00:00', '00:00', '0', NULL, NULL, 726, 9, 1, NULL, NULL, 0, 0),
(102, '00:00', '00:00', '0', NULL, NULL, 726, 10, 1, NULL, NULL, 0, 0),
(103, '00:32', '32:41', '60', '2018-02-15', '2018-02-15', 727, 1, 3, '08:53:59', '09:26:40', 0, 0),
(104, '00:35', '35:50', '60', '2018-02-15', '2018-02-15', 727, 3, 3, '10:24:39', '11:00:29', 0, 0),
(105, '00:22', '22:49', '60', '2018-02-15', '2018-02-15', 727, 4, 3, '11:04:09', '11:26:58', 0, 0),
(106, '00:01', '01:56', '60', '2018-02-15', '2018-02-15', 727, 5, 3, '12:22:05', '12:24:01', 0, 0),
(107, '01:20', '80:04', '60', '2018-02-15', '2018-02-15', 727, 6, 3, '13:19:58', '14:40:02', 0, 0),
(108, '00:06', '06:01', '60', '2018-02-15', '2018-02-15', 727, 7, 3, '14:43:37', '14:49:38', 0, 0),
(109, '00:12', '12:37', '60', '2018-02-15', '2018-02-15', 727, 8, 3, '15:29:08', '15:41:45', 0, 0),
(110, '00:00', '00:00', '0', NULL, NULL, 727, 9, 1, NULL, NULL, 0, 0),
(111, '00:00', '00:00', '0', NULL, NULL, 727, 10, 1, NULL, NULL, 0, 0),
(112, '01:49', '124:15', '68', '2018-02-16', '2018-02-16', 728, 1, 3, '07:16:23', '09:20:38', 0, 0),
(113, '00:00', '231:44', '0', '2018-02-16', NULL, 728, 2, 2, '12:42:26', '16:34:10', 68, 0),
(114, '00:00', '00:00', '0', NULL, NULL, 728, 3, 1, NULL, NULL, 0, 0),
(115, '00:00', '00:00', '0', NULL, NULL, 728, 4, 1, NULL, NULL, 0, 0),
(116, '00:00', '00:00', '0', NULL, NULL, 728, 5, 1, NULL, NULL, 0, 0),
(117, '00:00', '00:00', '0', NULL, NULL, 728, 6, 1, NULL, NULL, 0, 0),
(118, '00:00', '00:00', '0', NULL, NULL, 728, 7, 1, NULL, NULL, 0, 0),
(119, '00:00', '00:00', '0', NULL, NULL, 728, 8, 1, NULL, NULL, 0, 0),
(120, '00:00', '00:00', '0', NULL, NULL, 728, 9, 1, NULL, NULL, 0, 0),
(121, '00:00', '00:00', '0', NULL, NULL, 728, 10, 1, NULL, NULL, 0, 0),
(122, '00:00', '00:00', '0', NULL, NULL, 729, 1, 1, NULL, NULL, 0, 0),
(123, '00:00', '00:00', '0', NULL, NULL, 729, 3, 1, NULL, NULL, 0, 0),
(124, '00:00', '00:00', '0', NULL, NULL, 729, 4, 1, NULL, NULL, 0, 0),
(125, '00:00', '00:00', '0', NULL, NULL, 729, 5, 1, NULL, NULL, 0, 0),
(126, '00:00', '00:00', '0', NULL, NULL, 729, 6, 1, NULL, NULL, 0, 0),
(127, '00:00', '00:00', '0', NULL, NULL, 729, 7, 1, NULL, NULL, 0, 0),
(128, '00:00', '00:00', '0', NULL, NULL, 729, 8, 1, NULL, NULL, 0, 0),
(129, '00:00', '00:00', '0', NULL, NULL, 729, 10, 1, NULL, NULL, 0, 0),
(130, '00:00', '00:00', '0', NULL, NULL, 730, 1, 1, NULL, NULL, 0, 0),
(131, '00:00', '00:00', '0', NULL, NULL, 730, 2, 1, NULL, NULL, 0, 0),
(132, '00:00', '00:00', '0', NULL, NULL, 730, 3, 1, NULL, NULL, 0, 0),
(133, '00:00', '00:00', '0', NULL, NULL, 730, 4, 1, NULL, NULL, 0, 0),
(134, '00:00', '00:00', '0', NULL, NULL, 730, 5, 1, NULL, NULL, 0, 0),
(135, '00:00', '00:00', '0', NULL, NULL, 730, 6, 1, NULL, NULL, 0, 0),
(136, '00:00', '00:00', '0', NULL, NULL, 730, 7, 1, NULL, NULL, 0, 0),
(137, '00:00', '00:00', '0', NULL, NULL, 730, 8, 1, NULL, NULL, 0, 0),
(138, '00:00', '00:00', '0', NULL, NULL, 730, 9, 1, NULL, NULL, 0, 0),
(139, '00:00', '00:00', '0', NULL, NULL, 730, 10, 1, NULL, NULL, 0, 0),
(140, '04:03', '16:13', '4', '2018-02-15', '2018-02-15', 731, 1, 3, '09:24:10', '09:40:23', 0, 0),
(141, '53:24', '213:37', '4', '2018-02-15', '2018-02-15', 731, 2, 3, '10:14:56', '13:48:33', 0, 0),
(142, '06:14', '24:58', '4', '2018-02-15', '2018-02-15', 731, 3, 3, '15:13:04', '15:25:26', 0, 0),
(143, '13:34', '54:16', '4', '2018-02-15', '2018-02-15', 731, 4, 3, '15:29:18', '16:23:34', 0, 0),
(144, '00:58', '03:53', '4', '2018-02-15', '2018-02-15', 731, 5, 3, '16:25:07', '16:29:00', 0, 0),
(145, '00:00', '00:00', '0', NULL, NULL, 731, 6, 1, NULL, NULL, 0, 0),
(146, '00:00', '00:00', '0', NULL, NULL, 731, 7, 1, NULL, NULL, 0, 0),
(147, '00:00', '00:00', '0', NULL, NULL, 731, 8, 1, NULL, NULL, 0, 0),
(148, '00:00', '00:00', '0', NULL, NULL, 731, 10, 1, NULL, NULL, 0, 0),
(149, '00:00', '00:00', '0', NULL, NULL, 732, 1, 1, NULL, NULL, 0, 0),
(150, '00:00', '00:00', '0', NULL, NULL, 732, 2, 1, NULL, NULL, 0, 0),
(151, '00:00', '00:00', '0', NULL, NULL, 732, 3, 1, NULL, NULL, 0, 0),
(152, '00:00', '00:00', '0', NULL, NULL, 732, 4, 1, NULL, NULL, 0, 0),
(153, '00:00', '00:00', '0', NULL, NULL, 732, 5, 1, NULL, NULL, 0, 0),
(154, '00:00', '00:00', '0', NULL, NULL, 732, 6, 1, NULL, NULL, 0, 0),
(155, '00:00', '00:00', '0', NULL, NULL, 732, 7, 1, NULL, NULL, 0, 0),
(156, '00:00', '00:00', '0', NULL, NULL, 732, 8, 1, NULL, NULL, 0, 0),
(157, '00:00', '00:00', '0', NULL, NULL, 732, 10, 1, NULL, NULL, 0, 0),
(158, '00:00', '00:00', '0', NULL, NULL, 733, 1, 1, NULL, NULL, 0, 0),
(159, '00:00', '00:00', '0', NULL, NULL, 733, 2, 1, NULL, NULL, 0, 0),
(160, '00:00', '00:00', '0', NULL, NULL, 733, 3, 1, NULL, NULL, 0, 0),
(161, '00:00', '00:00', '0', NULL, NULL, 733, 4, 1, NULL, NULL, 0, 0),
(162, '00:00', '00:00', '0', NULL, NULL, 733, 5, 1, NULL, NULL, 0, 0),
(163, '00:00', '00:00', '0', NULL, NULL, 733, 7, 1, NULL, NULL, 0, 0),
(164, '00:00', '00:00', '0', NULL, NULL, 733, 8, 1, NULL, NULL, 0, 0),
(165, '00:00', '00:00', '0', NULL, NULL, 733, 9, 1, NULL, NULL, 0, 0),
(166, '00:00', '00:00', '0', NULL, NULL, 733, 10, 1, NULL, NULL, 0, 0),
(167, '00:00', '00:00', '0', NULL, NULL, 734, 1, 1, NULL, NULL, 0, 0),
(168, '00:00', '00:00', '0', NULL, NULL, 734, 2, 1, NULL, NULL, 0, 0),
(169, '00:00', '00:00', '0', NULL, NULL, 734, 3, 1, NULL, NULL, 0, 0),
(170, '00:00', '00:00', '0', NULL, NULL, 734, 4, 1, NULL, NULL, 0, 0),
(171, '00:00', '00:00', '0', NULL, NULL, 734, 5, 1, NULL, NULL, 0, 0),
(172, '00:00', '00:00', '0', NULL, NULL, 734, 6, 1, NULL, NULL, 0, 0),
(173, '00:00', '00:00', '0', NULL, NULL, 734, 7, 1, NULL, NULL, 0, 0),
(174, '00:00', '00:00', '0', NULL, NULL, 734, 8, 1, NULL, NULL, 0, 0),
(175, '00:00', '00:00', '0', NULL, NULL, 734, 9, 1, NULL, NULL, 0, 0),
(176, '00:00', '00:00', '0', NULL, NULL, 734, 10, 1, NULL, NULL, 0, 0),
(177, '00:00', '00:00', '0', NULL, NULL, 735, 1, 1, NULL, NULL, 0, 0),
(178, '00:00', '00:00', '0', NULL, NULL, 735, 3, 1, NULL, NULL, 0, 0),
(179, '00:00', '00:00', '0', NULL, NULL, 735, 4, 1, NULL, NULL, 0, 0),
(180, '00:00', '00:00', '0', NULL, NULL, 735, 5, 1, NULL, NULL, 0, 0),
(181, '00:00', '00:00', '0', NULL, NULL, 735, 7, 1, NULL, NULL, 0, 0),
(182, '00:00', '00:00', '0', NULL, NULL, 735, 8, 1, NULL, NULL, 0, 0),
(183, '00:00', '00:00', '0', NULL, NULL, 735, 9, 1, NULL, NULL, 0, 0),
(184, '00:00', '00:00', '0', NULL, NULL, 735, 10, 1, NULL, NULL, 0, 0),
(185, '00:00', '15:50', '0', '2018-02-19', NULL, 736, 1, 2, '09:51:16', '09:57:15', 100, 0),
(186, '00:00', '00:00', '0', NULL, NULL, 736, 3, 1, NULL, NULL, 0, 0),
(187, '00:00', '00:00', '0', NULL, NULL, 736, 4, 1, NULL, NULL, 0, 0),
(188, '00:00', '00:00', '0', NULL, NULL, 736, 5, 1, NULL, NULL, 0, 0),
(189, '00:00', '00:00', '0', NULL, NULL, 736, 7, 1, NULL, NULL, 0, 0),
(190, '00:00', '00:00', '0', NULL, NULL, 736, 8, 1, NULL, NULL, 0, 0),
(191, '00:00', '00:00', '0', NULL, NULL, 736, 9, 1, NULL, NULL, 0, 0),
(192, '00:00', '00:00', '0', NULL, NULL, 736, 10, 1, NULL, NULL, 0, 0),
(193, '00:00', '00:00', '0', NULL, NULL, 737, 1, 1, NULL, NULL, 0, 0),
(194, '00:00', '00:00', '0', NULL, NULL, 737, 2, 1, NULL, NULL, 0, 0),
(195, '00:00', '00:00', '0', NULL, NULL, 737, 3, 1, NULL, NULL, 0, 0),
(196, '00:00', '00:00', '0', NULL, NULL, 737, 4, 1, NULL, NULL, 0, 0),
(197, '00:00', '00:00', '0', NULL, NULL, 737, 5, 1, NULL, NULL, 0, 0),
(198, '00:00', '00:00', '0', NULL, NULL, 737, 6, 1, NULL, NULL, 0, 0),
(199, '00:00', '00:00', '0', NULL, NULL, 737, 7, 1, NULL, NULL, 0, 0),
(200, '00:00', '00:00', '0', NULL, NULL, 737, 8, 1, NULL, NULL, 0, 0),
(201, '00:00', '00:00', '0', NULL, NULL, 737, 9, 1, NULL, NULL, 0, 0),
(202, '00:00', '00:00', '0', NULL, NULL, 737, 10, 1, NULL, NULL, 0, 0),
(203, '00:00', '00:00', '0', NULL, NULL, 738, 1, 1, NULL, NULL, 0, 0),
(204, '00:00', '00:00', '0', NULL, NULL, 738, 2, 1, NULL, NULL, 0, 0),
(205, '00:00', '00:00', '0', NULL, NULL, 738, 3, 1, NULL, NULL, 0, 0),
(206, '00:00', '00:00', '0', NULL, NULL, 738, 4, 1, NULL, NULL, 0, 0),
(207, '00:00', '00:00', '0', NULL, NULL, 738, 5, 1, NULL, NULL, 0, 0),
(208, '00:00', '00:00', '0', NULL, NULL, 738, 6, 1, NULL, NULL, 0, 0),
(209, '00:00', '00:00', '0', NULL, NULL, 738, 7, 1, NULL, NULL, 0, 0),
(210, '00:00', '00:00', '0', NULL, NULL, 738, 8, 1, NULL, NULL, 0, 0),
(211, '00:00', '00:00', '0', NULL, NULL, 738, 9, 1, NULL, NULL, 0, 0),
(212, '00:00', '00:00', '0', NULL, NULL, 738, 10, 1, NULL, NULL, 0, 0),
(213, '00:00', '00:00', '0', NULL, NULL, 739, 1, 1, NULL, NULL, 0, 0),
(214, '00:00', '00:00', '0', NULL, NULL, 739, 2, 1, NULL, NULL, 0, 0),
(215, '00:00', '00:00', '0', NULL, NULL, 739, 3, 1, NULL, NULL, 0, 0),
(216, '00:00', '00:00', '0', NULL, NULL, 739, 4, 1, NULL, NULL, 0, 0),
(217, '00:00', '00:00', '0', NULL, NULL, 739, 5, 1, NULL, NULL, 0, 0),
(218, '00:00', '00:00', '0', NULL, NULL, 739, 6, 1, NULL, NULL, 0, 0),
(219, '00:00', '00:00', '0', NULL, NULL, 739, 7, 1, NULL, NULL, 0, 0),
(220, '00:00', '00:00', '0', NULL, NULL, 739, 8, 1, NULL, NULL, 0, 0),
(221, '00:00', '00:00', '0', NULL, NULL, 739, 10, 1, NULL, NULL, 0, 0),
(222, '01:50', '183:59', '100', '2018-02-16', '2018-02-16', 740, 1, 3, '15:16:32', '15:39:37', 0, 0),
(223, '00:00', '00:00', '0', NULL, NULL, 740, 2, 1, NULL, NULL, 0, 0),
(224, '00:00', '00:00', '0', NULL, NULL, 740, 3, 1, NULL, NULL, 0, 0),
(225, '00:00', '00:00', '0', NULL, NULL, 740, 4, 1, NULL, NULL, 0, 0),
(226, '00:00', '00:00', '0', NULL, NULL, 740, 5, 1, NULL, NULL, 0, 0),
(227, '00:00', '00:00', '0', NULL, NULL, 740, 6, 1, NULL, NULL, 0, 0),
(228, '00:00', '00:00', '0', NULL, NULL, 740, 7, 1, NULL, NULL, 0, 0),
(229, '00:00', '00:00', '0', NULL, NULL, 740, 8, 1, NULL, NULL, 0, 0),
(230, '00:00', '00:00', '0', NULL, NULL, 740, 9, 1, NULL, NULL, 0, 0),
(231, '00:00', '00:00', '0', NULL, NULL, 740, 10, 1, NULL, NULL, 0, 0),
(232, '00:00', '00:00', '0', NULL, NULL, 741, 1, 1, NULL, NULL, 0, 0),
(233, '00:00', '00:00', '0', NULL, NULL, 741, 3, 1, NULL, NULL, 0, 0),
(234, '00:00', '00:00', '0', NULL, NULL, 741, 4, 1, NULL, NULL, 0, 0),
(235, '00:00', '00:00', '0', NULL, NULL, 741, 5, 1, NULL, NULL, 0, 0),
(236, '00:00', '00:00', '0', NULL, NULL, 741, 6, 1, NULL, NULL, 0, 0),
(237, '00:00', '00:00', '0', NULL, NULL, 741, 7, 1, NULL, NULL, 0, 0),
(238, '00:00', '00:00', '0', NULL, NULL, 741, 8, 1, NULL, NULL, 0, 0),
(239, '00:00', '00:00', '0', NULL, NULL, 741, 9, 1, NULL, NULL, 0, 0),
(240, '00:00', '00:00', '0', NULL, NULL, 741, 10, 1, NULL, NULL, 0, 0),
(241, '00:00', '00:00', '0', NULL, NULL, 742, 1, 1, NULL, NULL, 0, 0),
(242, '00:00', '00:00', '0', NULL, NULL, 742, 2, 1, NULL, NULL, 0, 0),
(243, '00:00', '00:00', '0', NULL, NULL, 742, 3, 1, NULL, NULL, 0, 0),
(244, '00:00', '00:00', '0', NULL, NULL, 742, 4, 1, NULL, NULL, 0, 0),
(245, '00:00', '00:00', '0', NULL, NULL, 742, 5, 1, NULL, NULL, 0, 0),
(246, '00:00', '00:00', '0', NULL, NULL, 742, 6, 1, NULL, NULL, 0, 0),
(247, '00:00', '00:00', '0', NULL, NULL, 742, 7, 1, NULL, NULL, 0, 0),
(248, '00:00', '00:00', '0', NULL, NULL, 742, 8, 1, NULL, NULL, 0, 0),
(249, '00:00', '00:00', '0', NULL, NULL, 742, 10, 1, NULL, NULL, 0, 0),
(250, '04:47', '23:56', '5', '2018-02-19', '2018-02-19', 743, 1, 3, '08:51:30', '08:59:17', 0, 0),
(251, '52:56', '264:44', '5', '2018-02-19', '2018-02-19', 743, 2, 3, '10:53:05', '15:17:49', 0, 0),
(252, '00:00', '00:00', '0', NULL, NULL, 743, 3, 1, NULL, NULL, 0, 0),
(253, '00:00', '00:00', '0', NULL, NULL, 743, 4, 1, NULL, NULL, 0, 0),
(254, '00:00', '00:00', '0', NULL, NULL, 743, 5, 1, NULL, NULL, 0, 0),
(255, '00:00', '00:00', '0', NULL, NULL, 743, 7, 1, NULL, NULL, 0, 0),
(256, '00:00', '00:00', '0', NULL, NULL, 743, 8, 1, NULL, NULL, 0, 0),
(257, '00:00', '00:00', '0', NULL, NULL, 743, 10, 1, NULL, NULL, 0, 0),
(258, '16:05', '16:05', '1', '2018-02-16', '2018-02-16', 744, 1, 3, '06:30:08', '06:46:13', 0, 0),
(259, '229:16', '229:16', '1', '2018-02-16', '2018-02-16', 744, 2, 3, '12:42:49', '16:32:05', 0, 0),
(260, '00:00', '00:00', '0', NULL, NULL, 744, 3, 1, NULL, NULL, 0, 0),
(261, '00:00', '00:00', '0', NULL, NULL, 744, 4, 1, NULL, NULL, 0, 0),
(262, '00:00', '00:00', '0', NULL, NULL, 744, 5, 1, NULL, NULL, 0, 0),
(263, '00:00', '00:00', '0', NULL, NULL, 744, 6, 1, NULL, NULL, 0, 0),
(264, '00:00', '00:00', '0', NULL, NULL, 744, 7, 1, NULL, NULL, 0, 0),
(265, '00:00', '00:00', '0', NULL, NULL, 744, 8, 1, NULL, NULL, 0, 0),
(266, '00:00', '00:00', '0', NULL, NULL, 744, 10, 1, NULL, NULL, 0, 0),
(267, '00:00', '00:00', '0', NULL, NULL, 745, 1, 1, NULL, NULL, 0, 0),
(268, '00:00', '00:00', '0', NULL, NULL, 745, 2, 1, NULL, NULL, 0, 0),
(269, '00:00', '00:00', '0', NULL, NULL, 745, 3, 1, NULL, NULL, 0, 0),
(270, '00:00', '00:00', '0', NULL, NULL, 745, 4, 1, NULL, NULL, 0, 0),
(271, '00:00', '00:00', '0', NULL, NULL, 745, 5, 1, NULL, NULL, 0, 0),
(272, '00:00', '00:00', '0', NULL, NULL, 745, 6, 1, NULL, NULL, 0, 0),
(273, '00:00', '00:00', '0', NULL, NULL, 745, 7, 1, NULL, NULL, 0, 0),
(274, '00:00', '00:00', '0', NULL, NULL, 745, 8, 1, NULL, NULL, 0, 0),
(275, '00:00', '00:00', '0', NULL, NULL, 745, 10, 1, NULL, NULL, 0, 0),
(276, '00:00', '00:00', '0', NULL, NULL, 746, 1, 1, NULL, NULL, 0, 0),
(277, '00:00', '00:00', '0', NULL, NULL, 746, 2, 1, NULL, NULL, 0, 0),
(278, '00:00', '00:00', '0', NULL, NULL, 746, 3, 1, NULL, NULL, 0, 0),
(279, '00:00', '00:00', '0', NULL, NULL, 746, 4, 1, NULL, NULL, 0, 0),
(280, '00:00', '00:00', '0', NULL, NULL, 746, 5, 1, NULL, NULL, 0, 0),
(281, '00:00', '00:00', '0', NULL, NULL, 746, 6, 1, NULL, NULL, 0, 0),
(282, '00:00', '00:00', '0', NULL, NULL, 746, 7, 1, NULL, NULL, 0, 0),
(283, '00:00', '00:00', '0', NULL, NULL, 746, 8, 1, NULL, NULL, 0, 0),
(284, '00:00', '00:00', '0', NULL, NULL, 746, 10, 1, NULL, NULL, 0, 0),
(285, '00:00', '00:00', '0', NULL, NULL, 747, 1, 1, NULL, NULL, 0, 0),
(286, '00:00', '00:00', '0', NULL, NULL, 747, 3, 1, NULL, NULL, 0, 0),
(287, '00:00', '00:00', '0', NULL, NULL, 747, 4, 1, NULL, NULL, 0, 0),
(288, '00:00', '00:00', '0', NULL, NULL, 747, 5, 1, NULL, NULL, 0, 0),
(289, '00:00', '00:00', '0', NULL, NULL, 747, 6, 1, NULL, NULL, 0, 0),
(290, '00:00', '00:00', '0', NULL, NULL, 747, 7, 1, NULL, NULL, 0, 0),
(291, '00:00', '00:00', '0', NULL, NULL, 747, 8, 1, NULL, NULL, 0, 0),
(292, '00:00', '00:00', '0', NULL, NULL, 747, 10, 1, NULL, NULL, 0, 0),
(293, '00:00', '00:00', '0', NULL, NULL, 748, 1, 1, NULL, NULL, 0, 0),
(294, '00:00', '00:00', '0', NULL, NULL, 748, 3, 1, NULL, NULL, 0, 0),
(295, '00:00', '00:00', '0', NULL, NULL, 748, 4, 1, NULL, NULL, 0, 0),
(296, '00:00', '00:00', '0', NULL, NULL, 748, 5, 1, NULL, NULL, 0, 0),
(297, '00:00', '00:00', '0', NULL, NULL, 748, 6, 1, NULL, NULL, 0, 0),
(298, '00:00', '00:00', '0', NULL, NULL, 748, 7, 1, NULL, NULL, 0, 0),
(299, '00:00', '00:00', '0', NULL, NULL, 748, 8, 1, NULL, NULL, 0, 0),
(300, '00:00', '00:00', '0', NULL, NULL, 748, 10, 1, NULL, NULL, 0, 0),
(301, '04:10', '25:03', '6', '2018-02-19', '2018-02-19', 749, 1, 3, '07:29:20', '07:54:23', 0, 0),
(302, '06:52', '41:15', '6', '2018-02-19', '2018-02-19', 749, 3, 3, '11:21:26', '11:49:11', 0, 0),
(303, '10:15', '61:33', '6', '2018-02-19', '2018-02-19', 749, 4, 3, '14:44:32', '15:37:36', 0, 0),
(304, '01:00', '06:00', '6', '2018-02-19', '2018-02-19', 749, 5, 3, '15:55:59', '16:01:59', 0, 0),
(305, '00:00', '00:00', '0', NULL, NULL, 749, 6, 1, NULL, NULL, 0, 0),
(306, '00:00', '00:00', '0', NULL, NULL, 749, 7, 1, NULL, NULL, 0, 0),
(307, '00:00', '00:00', '0', NULL, NULL, 749, 8, 1, NULL, NULL, 0, 0),
(308, '00:00', '00:00', '0', NULL, NULL, 749, 10, 1, NULL, NULL, 0, 0),
(309, '00:13', '13:50', '60', '2018-02-19', '2018-02-19', 750, 1, 3, '07:58:37', '08:12:27', 0, 0),
(310, '00:51', '51:50', '60', '2018-02-20', '2018-02-20', 750, 3, 3, '11:19:02', '12:10:52', 0, 0),
(311, '00:00', '07:38', '0', '2018-02-20', NULL, 750, 4, 2, '13:21:36', '13:29:14', 60, 0),
(312, '00:00', '00:00', '0', NULL, NULL, 750, 5, 1, NULL, NULL, 0, 0),
(313, '00:00', '00:00', '0', NULL, NULL, 750, 7, 1, NULL, NULL, 0, 0),
(314, '00:00', '00:00', '0', NULL, NULL, 750, 8, 1, NULL, NULL, 0, 0),
(315, '00:00', '00:00', '0', NULL, NULL, 750, 9, 1, NULL, NULL, 0, 0),
(316, '00:00', '00:00', '0', NULL, NULL, 750, 10, 1, NULL, NULL, 0, 0),
(317, '00:00', '00:00', '0', NULL, NULL, 751, 1, 1, NULL, NULL, 0, 0),
(318, '00:00', '00:00', '0', NULL, NULL, 751, 2, 1, NULL, NULL, 0, 0),
(319, '00:00', '00:00', '0', NULL, NULL, 751, 3, 1, NULL, NULL, 0, 0),
(320, '00:00', '00:00', '0', NULL, NULL, 751, 4, 1, NULL, NULL, 0, 0),
(321, '00:00', '00:00', '0', NULL, NULL, 751, 5, 1, NULL, NULL, 0, 0),
(322, '00:00', '00:00', '0', NULL, NULL, 751, 7, 1, NULL, NULL, 0, 0),
(323, '00:00', '00:00', '0', NULL, NULL, 751, 8, 1, NULL, NULL, 0, 0),
(324, '00:00', '00:00', '0', NULL, NULL, 751, 9, 1, NULL, NULL, 0, 0),
(325, '00:00', '00:00', '0', NULL, NULL, 751, 10, 1, NULL, NULL, 0, 0),
(326, '00:00', '00:54', '0', '2018-02-20', NULL, 752, 1, 2, '08:57:03', '08:57:57', 50, 0),
(327, '00:00', '00:00', '0', NULL, NULL, 752, 2, 1, NULL, NULL, 0, 0),
(328, '00:00', '00:00', '0', NULL, NULL, 752, 3, 1, NULL, NULL, 0, 0),
(329, '00:00', '00:00', '0', NULL, NULL, 752, 4, 1, NULL, NULL, 0, 0),
(330, '00:00', '00:00', '0', NULL, NULL, 752, 5, 1, NULL, NULL, 0, 0),
(331, '00:00', '00:00', '0', NULL, NULL, 752, 6, 1, NULL, NULL, 0, 0),
(332, '00:00', '00:00', '0', NULL, NULL, 752, 7, 1, NULL, NULL, 0, 0),
(333, '00:00', '00:00', '0', NULL, NULL, 752, 8, 1, NULL, NULL, 0, 0),
(334, '00:00', '00:00', '0', NULL, NULL, 752, 9, 1, NULL, NULL, 0, 0),
(335, '00:00', '00:00', '0', NULL, NULL, 752, 10, 1, NULL, NULL, 0, 0),
(336, '00:00', '00:00', '0', NULL, NULL, 753, 1, 1, NULL, NULL, 0, 0),
(337, '00:00', '00:00', '0', NULL, NULL, 753, 2, 1, NULL, NULL, 0, 0),
(338, '00:00', '00:00', '0', NULL, NULL, 753, 3, 1, NULL, NULL, 0, 0),
(339, '00:00', '00:00', '0', NULL, NULL, 753, 4, 1, NULL, NULL, 0, 0),
(340, '00:00', '00:00', '0', NULL, NULL, 753, 5, 1, NULL, NULL, 0, 0),
(341, '00:00', '00:00', '0', NULL, NULL, 753, 7, 1, NULL, NULL, 0, 0),
(342, '00:00', '00:00', '0', NULL, NULL, 753, 8, 1, NULL, NULL, 0, 0),
(343, '00:00', '00:00', '0', NULL, NULL, 753, 9, 1, NULL, NULL, 0, 0),
(344, '00:00', '00:00', '0', NULL, NULL, 753, 10, 1, NULL, NULL, 0, 0),
(345, '00:00', '00:00', '0', NULL, NULL, 754, 1, 1, NULL, NULL, 0, 0),
(346, '00:00', '00:00', '0', NULL, NULL, 754, 3, 1, NULL, NULL, 0, 0),
(347, '00:00', '00:00', '0', NULL, NULL, 754, 4, 1, NULL, NULL, 0, 0),
(348, '00:00', '00:00', '0', NULL, NULL, 754, 5, 1, NULL, NULL, 0, 0),
(349, '00:00', '00:00', '0', NULL, NULL, 754, 6, 1, NULL, NULL, 0, 0),
(350, '00:00', '00:00', '0', NULL, NULL, 754, 7, 1, NULL, NULL, 0, 0),
(351, '00:00', '00:00', '0', NULL, NULL, 754, 8, 1, NULL, NULL, 0, 0),
(352, '00:00', '00:00', '0', NULL, NULL, 754, 9, 1, NULL, NULL, 0, 0),
(353, '00:00', '00:00', '0', NULL, NULL, 754, 10, 1, NULL, NULL, 0, 0),
(354, '00:00', '00:00', '0', NULL, NULL, 755, 1, 1, NULL, NULL, 0, 0),
(355, '00:00', '00:00', '0', NULL, NULL, 755, 3, 1, NULL, NULL, 0, 0),
(356, '00:00', '00:00', '0', NULL, NULL, 755, 4, 1, NULL, NULL, 0, 0),
(357, '00:00', '00:00', '0', NULL, NULL, 755, 5, 1, NULL, NULL, 0, 0),
(358, '00:00', '00:00', '0', NULL, NULL, 755, 6, 1, NULL, NULL, 0, 0),
(359, '00:00', '00:00', '0', NULL, NULL, 755, 7, 1, NULL, NULL, 0, 0),
(360, '00:00', '00:00', '0', NULL, NULL, 755, 8, 1, NULL, NULL, 0, 0),
(361, '00:00', '00:00', '0', NULL, NULL, 755, 9, 1, NULL, NULL, 0, 0),
(362, '00:00', '00:00', '0', NULL, NULL, 755, 10, 1, NULL, NULL, 0, 0),
(363, '02:06', '21:03', '10', '2018-02-19', '2018-02-19', 756, 1, 3, '10:01:14', '10:22:17', 0, 0),
(364, '00:00', '00:00', '0', '2018-02-20', NULL, 756, 2, 4, '14:15:21', NULL, 0, 1),
(365, '00:00', '00:00', '0', NULL, NULL, 756, 3, 1, NULL, NULL, 0, 0),
(366, '00:00', '00:00', '0', NULL, NULL, 756, 4, 1, NULL, NULL, 0, 0),
(367, '00:00', '00:00', '0', NULL, NULL, 756, 5, 1, NULL, NULL, 0, 0),
(368, '00:00', '00:00', '0', NULL, NULL, 756, 6, 1, NULL, NULL, 0, 0),
(369, '00:00', '00:00', '0', NULL, NULL, 756, 7, 1, NULL, NULL, 0, 0),
(370, '00:00', '00:00', '0', NULL, NULL, 756, 8, 1, NULL, NULL, 0, 0),
(371, '00:00', '00:00', '0', NULL, NULL, 756, 10, 1, NULL, NULL, 0, 0),
(372, '04:58', '49:41', '10', '2018-02-20', '2018-02-20', 757, 1, 3, '11:08:49', '11:58:30', 0, 0),
(373, '00:00', '00:00', '0', '2018-02-20', NULL, 757, 2, 4, '13:55:51', NULL, 0, 1),
(374, '00:00', '00:00', '0', NULL, NULL, 757, 3, 1, NULL, NULL, 0, 0),
(375, '00:00', '00:00', '0', NULL, NULL, 757, 4, 1, NULL, NULL, 0, 0),
(376, '00:00', '00:00', '0', NULL, NULL, 757, 5, 1, NULL, NULL, 0, 0),
(377, '00:00', '00:00', '0', NULL, NULL, 757, 6, 1, NULL, NULL, 0, 0),
(378, '00:00', '00:00', '0', NULL, NULL, 757, 7, 1, NULL, NULL, 0, 0),
(379, '00:00', '00:00', '0', NULL, NULL, 757, 8, 1, NULL, NULL, 0, 0),
(380, '00:00', '00:00', '0', NULL, NULL, 757, 10, 1, NULL, NULL, 0, 0),
(381, '01:03', '210:44', '200', '2018-02-15', '2018-02-15', 758, 1, 3, '16:07:09', '16:44:59', 0, 0),
(382, '00:00', '34:12', '96', '2018-02-15', NULL, 758, 3, 2, '16:07:52', '16:42:04', 104, 0),
(383, '00:00', '00:00', '0', NULL, NULL, 758, 4, 1, NULL, NULL, 0, 0),
(384, '00:00', '00:00', '0', NULL, NULL, 758, 5, 1, NULL, NULL, 0, 0),
(385, '00:00', '00:00', '0', NULL, NULL, 758, 6, 1, NULL, NULL, 0, 0),
(386, '00:00', '00:00', '0', NULL, NULL, 758, 7, 1, NULL, NULL, 0, 0),
(387, '00:00', '00:00', '0', NULL, NULL, 758, 8, 1, NULL, NULL, 0, 0),
(388, '00:00', '00:00', '0', NULL, NULL, 758, 9, 1, NULL, NULL, 0, 0),
(389, '00:00', '00:00', '0', NULL, NULL, 758, 10, 1, NULL, NULL, 0, 0),
(390, '09:01', '27:05', '3', '2018-02-15', '2018-02-15', 759, 1, 3, '08:02:35', '08:29:40', 0, 0),
(391, '78:58', '236:54', '3', '2018-02-15', '2018-02-15', 759, 2, 3, '09:20:46', '13:17:40', 0, 0),
(392, '13:49', '41:29', '3', '2018-02-15', '2018-02-15', 759, 3, 3, '14:31:33', '14:50:09', 0, 0),
(393, '20:07', '60:21', '3', '2018-02-15', '2018-02-15', 759, 4, 3, '15:03:40', '16:04:01', 0, 0),
(394, '04:00', '12:00', '3', '2018-02-15', '2018-02-15', 759, 5, 3, '16:15:22', '16:27:22', 0, 0),
(395, '00:00', '00:00', '0', NULL, NULL, 759, 6, 1, NULL, NULL, 0, 0),
(396, '00:00', '00:00', '0', NULL, NULL, 759, 7, 1, NULL, NULL, 0, 0),
(397, '00:00', '00:00', '0', NULL, NULL, 759, 8, 1, NULL, NULL, 0, 0),
(398, '00:00', '00:00', '0', NULL, NULL, 759, 9, 1, NULL, NULL, 0, 0),
(399, '00:00', '00:00', '0', NULL, NULL, 759, 10, 1, NULL, NULL, 0, 0),
(400, '05:31', '11:02', '2', '2018-02-15', '2018-02-15', 760, 1, 3, '12:01:01', '12:12:03', 0, 0),
(401, '00:00', '00:00', '0', NULL, NULL, 760, 2, 1, NULL, NULL, 0, 0),
(402, '00:00', '00:00', '0', NULL, NULL, 760, 3, 1, NULL, NULL, 0, 0),
(403, '00:00', '00:00', '0', NULL, NULL, 760, 4, 1, NULL, NULL, 0, 0),
(404, '00:00', '00:00', '0', NULL, NULL, 760, 5, 1, NULL, NULL, 0, 0),
(405, '00:00', '00:00', '0', NULL, NULL, 760, 6, 1, NULL, NULL, 0, 0),
(406, '00:00', '00:00', '0', NULL, NULL, 760, 7, 1, NULL, NULL, 0, 0),
(407, '00:00', '00:00', '0', NULL, NULL, 760, 8, 1, NULL, NULL, 0, 0),
(408, '00:00', '00:00', '0', NULL, NULL, 760, 10, 1, NULL, NULL, 0, 0),
(409, '00:00', '00:00', '0', NULL, NULL, 761, 1, 1, NULL, NULL, 0, 0),
(410, '00:00', '00:00', '0', NULL, NULL, 761, 2, 1, NULL, NULL, 0, 0),
(411, '00:00', '00:00', '0', NULL, NULL, 761, 3, 1, NULL, NULL, 0, 0),
(412, '00:00', '00:00', '0', NULL, NULL, 761, 4, 1, NULL, NULL, 0, 0),
(413, '00:00', '00:00', '0', NULL, NULL, 761, 5, 1, NULL, NULL, 0, 0),
(414, '00:00', '00:00', '0', NULL, NULL, 761, 6, 1, NULL, NULL, 0, 0),
(415, '00:00', '00:00', '0', NULL, NULL, 761, 7, 1, NULL, NULL, 0, 0),
(416, '00:00', '00:00', '0', NULL, NULL, 761, 8, 1, NULL, NULL, 0, 0),
(417, '00:00', '00:00', '0', NULL, NULL, 761, 10, 1, NULL, NULL, 0, 0),
(418, '00:56', '09:20', '10', '2018-02-15', '2018-02-15', 762, 1, 3, '09:33:06', '09:42:26', 0, 0),
(419, '21:24', '214:05', '10', '2018-02-15', '2018-02-15', 762, 2, 3, '10:14:14', '13:48:19', 0, 0),
(420, '04:08', '41:21', '10', '2018-02-15', '2018-02-15', 762, 3, 3, '14:31:20', '14:50:24', 0, 0),
(421, '06:07', '61:12', '10', '2018-02-15', '2018-02-15', 762, 4, 3, '15:03:17', '16:04:29', 0, 0),
(422, '01:23', '13:58', '10', '2018-02-15', '2018-02-15', 762, 5, 3, '16:13:55', '16:27:53', 0, 0),
(423, '16:00', '160:00', '10', '2018-02-16', '2018-02-16', 762, 6, 3, '08:53:04', '11:19:15', 0, 0),
(424, '00:38', '06:23', '10', '2018-02-16', '2018-02-16', 762, 7, 3, '11:51:24', '11:57:47', 0, 0),
(425, '01:05', '10:54', '10', '2018-02-16', '2018-02-16', 762, 8, 3, '11:58:27', '12:09:21', 0, 0),
(426, '01:39', '16:30', '10', '2018-02-16', '2018-02-16', 762, 10, 3, '13:49:38', '14:06:08', 0, 0),
(427, '00:00', '00:00', '0', NULL, NULL, 763, 1, 1, NULL, NULL, 0, 0),
(428, '00:00', '00:00', '0', NULL, NULL, 763, 3, 1, NULL, NULL, 0, 0),
(429, '00:00', '00:00', '0', NULL, NULL, 763, 4, 1, NULL, NULL, 0, 0),
(430, '00:00', '00:00', '0', NULL, NULL, 763, 5, 1, NULL, NULL, 0, 0),
(431, '00:00', '00:00', '0', NULL, NULL, 763, 6, 1, NULL, NULL, 0, 0),
(432, '00:00', '00:00', '0', NULL, NULL, 763, 7, 1, NULL, NULL, 0, 0),
(433, '00:00', '00:00', '0', NULL, NULL, 763, 8, 1, NULL, NULL, 0, 0),
(434, '00:00', '00:00', '0', NULL, NULL, 763, 9, 1, NULL, NULL, 0, 0),
(435, '00:00', '00:00', '0', NULL, NULL, 763, 10, 1, NULL, NULL, 0, 0),
(436, '00:00', '00:00', '0', NULL, NULL, 764, 1, 1, NULL, NULL, 0, 0),
(437, '00:00', '00:00', '0', NULL, NULL, 764, 2, 1, NULL, NULL, 0, 0),
(438, '00:00', '00:00', '0', NULL, NULL, 764, 3, 1, NULL, NULL, 0, 0),
(439, '00:00', '00:00', '0', NULL, NULL, 764, 4, 1, NULL, NULL, 0, 0),
(440, '00:00', '00:00', '0', NULL, NULL, 764, 5, 1, NULL, NULL, 0, 0),
(441, '00:00', '00:00', '0', NULL, NULL, 764, 6, 1, NULL, NULL, 0, 0),
(442, '00:00', '00:00', '0', NULL, NULL, 764, 7, 1, NULL, NULL, 0, 0),
(443, '00:00', '00:00', '0', NULL, NULL, 764, 8, 1, NULL, NULL, 0, 0),
(444, '00:00', '00:00', '0', NULL, NULL, 764, 9, 1, NULL, NULL, 0, 0),
(445, '00:00', '00:00', '0', NULL, NULL, 764, 10, 1, NULL, NULL, 0, 0),
(446, '00:00', '00:00', '0', NULL, NULL, 765, 1, 1, NULL, NULL, 0, 0),
(447, '00:00', '00:00', '0', NULL, NULL, 765, 3, 1, NULL, NULL, 0, 0),
(448, '00:00', '00:00', '0', NULL, NULL, 765, 4, 1, NULL, NULL, 0, 0),
(449, '00:00', '00:00', '0', NULL, NULL, 765, 5, 1, NULL, NULL, 0, 0),
(450, '00:00', '00:00', '0', NULL, NULL, 765, 6, 1, NULL, NULL, 0, 0),
(451, '00:00', '00:00', '0', NULL, NULL, 765, 7, 1, NULL, NULL, 0, 0),
(452, '00:00', '00:00', '0', NULL, NULL, 765, 8, 1, NULL, NULL, 0, 0),
(453, '00:00', '00:00', '0', NULL, NULL, 765, 9, 1, NULL, NULL, 0, 0),
(454, '00:00', '00:00', '0', NULL, NULL, 765, 10, 1, NULL, NULL, 0, 0),
(455, '00:00', '00:00', '0', NULL, NULL, 766, 1, 1, NULL, NULL, 0, 0),
(456, '00:00', '00:00', '0', NULL, NULL, 766, 2, 1, NULL, NULL, 0, 0),
(457, '00:00', '00:00', '0', NULL, NULL, 766, 3, 1, NULL, NULL, 0, 0),
(458, '00:00', '00:00', '0', NULL, NULL, 766, 4, 1, NULL, NULL, 0, 0),
(459, '00:00', '00:00', '0', NULL, NULL, 766, 5, 1, NULL, NULL, 0, 0),
(460, '00:00', '00:00', '0', NULL, NULL, 766, 7, 1, NULL, NULL, 0, 0),
(461, '00:00', '00:00', '0', NULL, NULL, 766, 8, 1, NULL, NULL, 0, 0),
(462, '00:00', '00:00', '0', NULL, NULL, 766, 9, 1, NULL, NULL, 0, 0),
(463, '00:00', '00:00', '0', NULL, NULL, 766, 10, 1, NULL, NULL, 0, 0),
(464, '00:00', '00:00', '0', NULL, NULL, 767, 1, 1, NULL, NULL, 0, 0),
(465, '00:00', '00:00', '0', NULL, NULL, 767, 3, 1, NULL, NULL, 0, 0),
(466, '00:00', '00:00', '0', NULL, NULL, 767, 4, 1, NULL, NULL, 0, 0),
(467, '00:00', '00:00', '0', NULL, NULL, 767, 5, 1, NULL, NULL, 0, 0),
(468, '00:00', '00:00', '0', NULL, NULL, 767, 6, 1, NULL, NULL, 0, 0),
(469, '00:00', '00:00', '0', NULL, NULL, 767, 7, 1, NULL, NULL, 0, 0),
(470, '00:00', '00:00', '0', NULL, NULL, 767, 8, 1, NULL, NULL, 0, 0),
(471, '00:00', '00:00', '0', NULL, NULL, 767, 9, 1, NULL, NULL, 0, 0),
(472, '00:00', '00:00', '0', NULL, NULL, 767, 10, 1, NULL, NULL, 0, 0),
(473, '00:00', '00:00', '0', NULL, NULL, 768, 1, 1, NULL, NULL, 0, 0),
(474, '00:00', '00:00', '0', NULL, NULL, 768, 3, 1, NULL, NULL, 0, 0),
(475, '00:00', '00:00', '0', NULL, NULL, 768, 4, 1, NULL, NULL, 0, 0),
(476, '00:00', '00:00', '0', NULL, NULL, 768, 5, 1, NULL, NULL, 0, 0),
(477, '00:00', '00:00', '0', NULL, NULL, 768, 6, 1, NULL, NULL, 0, 0),
(478, '00:00', '00:00', '0', NULL, NULL, 768, 7, 1, NULL, NULL, 0, 0),
(479, '00:00', '00:00', '0', NULL, NULL, 768, 8, 1, NULL, NULL, 0, 0),
(480, '00:00', '00:00', '0', NULL, NULL, 768, 9, 1, NULL, NULL, 0, 0),
(481, '00:00', '00:00', '0', NULL, NULL, 768, 10, 1, NULL, NULL, 0, 0),
(482, '02:39', '53:09', '20', '2018-02-20', '2018-02-20', 769, 1, 3, '09:51:43', '10:44:52', 0, 0),
(483, '00:00', '00:00', '0', '2018-02-20', NULL, 769, 2, 4, '13:53:29', NULL, 0, 1),
(484, '00:00', '00:00', '0', NULL, NULL, 769, 3, 1, NULL, NULL, 0, 0),
(485, '00:00', '00:00', '0', NULL, NULL, 769, 4, 1, NULL, NULL, 0, 0),
(486, '00:00', '00:00', '0', NULL, NULL, 769, 5, 1, NULL, NULL, 0, 0),
(487, '00:00', '00:00', '0', NULL, NULL, 769, 6, 1, NULL, NULL, 0, 0),
(488, '00:00', '00:00', '0', NULL, NULL, 769, 7, 1, NULL, NULL, 0, 0),
(489, '00:00', '00:00', '0', NULL, NULL, 769, 8, 1, NULL, NULL, 0, 0),
(490, '00:00', '00:00', '0', NULL, NULL, 769, 9, 1, NULL, NULL, 0, 0),
(491, '00:00', '00:00', '0', NULL, NULL, 769, 10, 1, NULL, NULL, 0, 0),
(492, '00:00', '00:00', '0', NULL, NULL, 770, 1, 1, NULL, NULL, 0, 0),
(493, '00:00', '00:00', '0', NULL, NULL, 770, 3, 1, NULL, NULL, 0, 0),
(494, '00:00', '00:00', '0', NULL, NULL, 770, 4, 1, NULL, NULL, 0, 0),
(495, '00:00', '00:00', '0', NULL, NULL, 770, 5, 1, NULL, NULL, 0, 0),
(496, '00:00', '00:00', '0', NULL, NULL, 770, 6, 1, NULL, NULL, 0, 0),
(497, '00:00', '00:00', '0', NULL, NULL, 770, 7, 1, NULL, NULL, 0, 0),
(498, '00:00', '00:00', '0', NULL, NULL, 770, 8, 1, NULL, NULL, 0, 0),
(499, '00:00', '00:00', '0', NULL, NULL, 770, 9, 1, NULL, NULL, 0, 0),
(500, '00:00', '00:00', '0', NULL, NULL, 770, 10, 1, NULL, NULL, 0, 0),
(501, '00:00', '00:00', '0', NULL, NULL, 771, 1, 1, NULL, NULL, 0, 0),
(502, '00:00', '00:00', '0', NULL, NULL, 771, 3, 1, NULL, NULL, 0, 0),
(503, '00:00', '00:00', '0', NULL, NULL, 771, 4, 1, NULL, NULL, 0, 0),
(504, '00:00', '00:00', '0', NULL, NULL, 771, 5, 1, NULL, NULL, 0, 0),
(505, '00:00', '00:00', '0', NULL, NULL, 771, 6, 1, NULL, NULL, 0, 0),
(506, '00:00', '00:00', '0', NULL, NULL, 771, 7, 1, NULL, NULL, 0, 0),
(507, '00:00', '00:00', '0', NULL, NULL, 771, 8, 1, NULL, NULL, 0, 0),
(508, '00:00', '00:00', '0', NULL, NULL, 771, 9, 1, NULL, NULL, 0, 0),
(509, '00:00', '00:00', '0', NULL, NULL, 771, 10, 1, NULL, NULL, 0, 0),
(510, '00:00', '00:00', '0', NULL, NULL, 772, 1, 1, NULL, NULL, 0, 0),
(511, '00:00', '00:00', '0', NULL, NULL, 772, 2, 1, NULL, NULL, 0, 0),
(512, '00:00', '00:00', '0', NULL, NULL, 772, 3, 1, NULL, NULL, 0, 0),
(513, '00:00', '00:00', '0', NULL, NULL, 772, 4, 1, NULL, NULL, 0, 0),
(514, '00:00', '00:00', '0', NULL, NULL, 772, 5, 1, NULL, NULL, 0, 0),
(515, '00:00', '00:00', '0', NULL, NULL, 772, 6, 1, NULL, NULL, 0, 0),
(516, '00:00', '00:00', '0', NULL, NULL, 772, 7, 1, NULL, NULL, 0, 0),
(517, '00:00', '00:00', '0', NULL, NULL, 772, 8, 1, NULL, NULL, 0, 0),
(518, '00:00', '00:00', '0', NULL, NULL, 772, 9, 1, NULL, NULL, 0, 0),
(519, '00:00', '00:00', '0', NULL, NULL, 772, 10, 1, NULL, NULL, 0, 0),
(520, '00:00', '00:00', '0', NULL, NULL, 773, 1, 1, NULL, NULL, 0, 0),
(521, '00:00', '00:00', '0', NULL, NULL, 773, 2, 1, NULL, NULL, 0, 0),
(522, '00:00', '00:00', '0', NULL, NULL, 773, 3, 1, NULL, NULL, 0, 0),
(523, '00:00', '00:00', '0', NULL, NULL, 773, 4, 1, NULL, NULL, 0, 0),
(524, '00:00', '00:00', '0', NULL, NULL, 773, 5, 1, NULL, NULL, 0, 0),
(525, '00:00', '00:00', '0', NULL, NULL, 773, 6, 1, NULL, NULL, 0, 0),
(526, '00:00', '00:00', '0', NULL, NULL, 773, 7, 1, NULL, NULL, 0, 0),
(527, '00:00', '00:00', '0', NULL, NULL, 773, 8, 1, NULL, NULL, 0, 0),
(528, '00:00', '00:00', '0', NULL, NULL, 773, 9, 1, NULL, NULL, 0, 0),
(529, '00:00', '00:00', '0', NULL, NULL, 773, 10, 1, NULL, NULL, 0, 0),
(530, '00:00', '00:00', '0', NULL, NULL, 774, 1, 1, NULL, NULL, 0, 0),
(531, '00:00', '00:00', '0', NULL, NULL, 774, 3, 1, NULL, NULL, 0, 0),
(532, '00:00', '00:00', '0', NULL, NULL, 774, 4, 1, NULL, NULL, 0, 0),
(533, '00:00', '00:00', '0', NULL, NULL, 774, 5, 1, NULL, NULL, 0, 0),
(534, '00:00', '00:00', '0', NULL, NULL, 774, 7, 1, NULL, NULL, 0, 0),
(535, '00:00', '00:00', '0', NULL, NULL, 774, 8, 1, NULL, NULL, 0, 0),
(536, '00:00', '00:00', '0', NULL, NULL, 774, 9, 1, NULL, NULL, 0, 0),
(537, '00:00', '00:00', '0', NULL, NULL, 774, 10, 1, NULL, NULL, 0, 0),
(538, '20:32', '20:32', '1', '2018-02-19', '2018-02-19', 775, 1, 3, '07:04:47', '07:25:19', 0, 0),
(539, '25:45', '25:45', '1', '2018-02-19', '2018-02-19', 775, 4, 3, '09:50:55', '10:16:40', 0, 0),
(540, '22:06', '22:06', '1', '2018-02-19', '2018-02-19', 776, 1, 3, '07:04:31', '07:26:37', 0, 0),
(541, '25:12', '25:12', '1', '2018-02-19', '2018-02-19', 776, 4, 3, '09:50:24', '10:15:36', 0, 0),
(542, '22:38', '22:38', '1', '2018-02-19', '2018-02-19', 777, 1, 3, '07:04:16', '07:26:54', 0, 0),
(543, '26:37', '26:37', '1', '2018-02-19', '2018-02-19', 777, 4, 3, '09:51:07', '10:17:44', 0, 0),
(544, '00:19', '09:41', '30', '2018-02-19', '2018-02-19', 778, 1, 3, '12:05:53', '12:15:34', 0, 0),
(545, '00:00', '147:40', '0', '2018-02-19', NULL, 778, 2, 2, '14:01:13', '16:28:53', 30, 0),
(546, '00:00', '00:00', '0', NULL, NULL, 778, 3, 1, NULL, NULL, 0, 0),
(547, '00:00', '00:00', '0', NULL, NULL, 778, 4, 1, NULL, NULL, 0, 0),
(548, '00:00', '00:00', '0', NULL, NULL, 778, 5, 1, NULL, NULL, 0, 0),
(549, '00:00', '00:00', '0', NULL, NULL, 778, 6, 1, NULL, NULL, 0, 0),
(550, '00:00', '00:00', '0', NULL, NULL, 778, 7, 1, NULL, NULL, 0, 0),
(551, '00:00', '00:00', '0', NULL, NULL, 778, 8, 1, NULL, NULL, 0, 0),
(552, '00:00', '00:00', '0', NULL, NULL, 778, 9, 1, NULL, NULL, 0, 0),
(553, '00:00', '00:00', '0', NULL, NULL, 778, 10, 1, NULL, NULL, 0, 0),
(554, '14:47', '14:47', '1', '2018-02-19', '2018-02-19', 779, 1, 3, '13:19:13', '13:34:00', 0, 0),
(555, '19:56', '19:56', '1', '2018-02-19', '2018-02-19', 779, 3, 3, '13:49:45', '14:09:41', 0, 0),
(556, '14:04', '14:04', '1', '2018-02-19', '2018-02-19', 779, 4, 3, '14:37:33', '14:51:37', 0, 0),
(557, '02:15', '02:15', '1', '2018-02-19', '2018-02-19', 779, 5, 3, '14:53:15', '14:55:30', 0, 0),
(558, '20:53', '20:53', '1', '2018-02-19', '2018-02-19', 779, 6, 3, '16:03:52', '16:24:45', 0, 0),
(559, '00:00', '00:00', '0', NULL, NULL, 779, 7, 1, NULL, NULL, 0, 0),
(560, '00:00', '00:00', '0', NULL, NULL, 779, 8, 1, NULL, NULL, 0, 0),
(561, '00:00', '00:00', '0', NULL, NULL, 779, 10, 1, NULL, NULL, 0, 0),
(562, '04:01', '08:03', '2', '2018-02-19', '2018-02-19', 780, 1, 3, '13:52:26', '13:52:55', 0, 0),
(563, '00:00', '148:10', '0', '2018-02-19', NULL, 780, 2, 2, '14:01:21', '16:29:31', 2, 0),
(564, '00:00', '00:00', '0', NULL, NULL, 780, 3, 1, NULL, NULL, 0, 0),
(565, '00:00', '00:00', '0', NULL, NULL, 780, 4, 1, NULL, NULL, 0, 0),
(566, '00:00', '00:00', '0', NULL, NULL, 780, 5, 1, NULL, NULL, 0, 0),
(567, '00:00', '00:00', '0', NULL, NULL, 780, 6, 1, NULL, NULL, 0, 0),
(568, '00:00', '00:00', '0', NULL, NULL, 780, 7, 1, NULL, NULL, 0, 0),
(569, '00:00', '00:00', '0', NULL, NULL, 780, 8, 1, NULL, NULL, 0, 0),
(570, '00:00', '00:00', '0', NULL, NULL, 780, 10, 1, NULL, NULL, 0, 0),
(571, '00:00', '00:00', '0', NULL, NULL, 781, 1, 1, NULL, NULL, 0, 0),
(572, '00:00', '00:00', '0', NULL, NULL, 781, 2, 1, NULL, NULL, 0, 0),
(573, '00:00', '00:00', '0', NULL, NULL, 781, 3, 1, NULL, NULL, 0, 0),
(574, '00:00', '00:00', '0', NULL, NULL, 781, 4, 1, NULL, NULL, 0, 0),
(575, '00:00', '00:00', '0', NULL, NULL, 781, 5, 1, NULL, NULL, 0, 0),
(576, '00:00', '00:00', '0', NULL, NULL, 781, 6, 1, NULL, NULL, 0, 0),
(577, '00:00', '00:00', '0', NULL, NULL, 781, 7, 1, NULL, NULL, 0, 0),
(578, '00:00', '00:00', '0', NULL, NULL, 781, 8, 1, NULL, NULL, 0, 0),
(579, '00:00', '00:00', '0', NULL, NULL, 781, 10, 1, NULL, NULL, 0, 0),
(580, '00:00', '00:00', '0', NULL, NULL, 782, 1, 1, NULL, NULL, 0, 0),
(581, '00:00', '00:00', '0', NULL, NULL, 782, 2, 1, NULL, NULL, 0, 0),
(582, '00:00', '00:00', '0', NULL, NULL, 782, 3, 1, NULL, NULL, 0, 0),
(583, '00:00', '00:00', '0', NULL, NULL, 782, 4, 1, NULL, NULL, 0, 0),
(584, '00:00', '00:00', '0', NULL, NULL, 782, 5, 1, NULL, NULL, 0, 0),
(585, '00:00', '00:00', '0', NULL, NULL, 782, 6, 1, NULL, NULL, 0, 0),
(586, '00:00', '00:00', '0', NULL, NULL, 782, 7, 1, NULL, NULL, 0, 0),
(587, '00:00', '00:00', '0', NULL, NULL, 782, 8, 1, NULL, NULL, 0, 0),
(588, '00:00', '00:00', '0', NULL, NULL, 782, 10, 1, NULL, NULL, 0, 0),
(589, '27:04', '54:08', '2', '2018-02-20', '2018-02-20', 783, 1, 3, '09:51:29', '10:45:37', 0, 0),
(590, '00:00', '00:00', '0', '2018-02-20', NULL, 783, 2, 4, '13:55:30', NULL, 0, 1),
(591, '00:00', '00:00', '0', NULL, NULL, 783, 3, 1, NULL, NULL, 0, 0),
(592, '00:00', '00:00', '0', NULL, NULL, 783, 4, 1, NULL, NULL, 0, 0),
(593, '00:00', '00:00', '0', NULL, NULL, 783, 5, 1, NULL, NULL, 0, 0),
(594, '00:00', '00:00', '0', NULL, NULL, 783, 6, 1, NULL, NULL, 0, 0),
(595, '00:00', '00:00', '0', NULL, NULL, 783, 7, 1, NULL, NULL, 0, 0),
(596, '00:00', '00:00', '0', NULL, NULL, 783, 8, 1, NULL, NULL, 0, 0),
(597, '00:00', '00:00', '0', NULL, NULL, 783, 10, 1, NULL, NULL, 0, 0),
(598, '54:21', '54:21', '1', '2018-02-20', '2018-02-20', 784, 1, 3, '09:51:36', '10:45:57', 0, 0),
(599, '00:00', '00:00', '0', '2018-02-20', NULL, 784, 2, 4, '13:52:36', NULL, 0, 1),
(600, '00:00', '00:00', '0', NULL, NULL, 784, 3, 1, NULL, NULL, 0, 0),
(601, '00:00', '00:00', '0', NULL, NULL, 784, 4, 1, NULL, NULL, 0, 0),
(602, '00:00', '00:00', '0', NULL, NULL, 784, 5, 1, NULL, NULL, 0, 0),
(603, '00:00', '00:00', '0', NULL, NULL, 784, 6, 1, NULL, NULL, 0, 0),
(604, '00:00', '00:00', '0', NULL, NULL, 784, 7, 1, NULL, NULL, 0, 0),
(605, '00:00', '00:00', '0', NULL, NULL, 784, 8, 1, NULL, NULL, 0, 0),
(606, '00:00', '00:00', '0', NULL, NULL, 784, 10, 1, NULL, NULL, 0, 0),
(607, '55:57', '55:57', '1', '2018-02-20', '2018-02-20', 785, 1, 3, '09:51:55', '10:47:52', 0, 0),
(608, '00:00', '00:00', '0', '2018-02-20', NULL, 785, 2, 4, '13:55:42', NULL, 0, 1),
(609, '00:00', '00:00', '0', NULL, NULL, 785, 3, 1, NULL, NULL, 0, 0),
(610, '00:00', '00:00', '0', NULL, NULL, 785, 4, 1, NULL, NULL, 0, 0),
(611, '00:00', '00:00', '0', NULL, NULL, 785, 5, 1, NULL, NULL, 0, 0),
(612, '00:00', '00:00', '0', NULL, NULL, 785, 6, 1, NULL, NULL, 0, 0),
(613, '00:00', '00:00', '0', NULL, NULL, 785, 7, 1, NULL, NULL, 0, 0),
(614, '00:00', '00:00', '0', NULL, NULL, 785, 8, 1, NULL, NULL, 0, 0),
(615, '00:00', '00:00', '0', NULL, NULL, 785, 10, 1, NULL, NULL, 0, 0),
(616, '05:25', '54:16', '10', '2018-02-20', '2018-02-20', 786, 1, 3, '09:52:04', '10:46:20', 0, 0),
(617, '00:00', '00:00', '0', '2018-02-20', NULL, 786, 2, 4, '13:53:16', NULL, 0, 1),
(618, '00:00', '00:00', '0', NULL, NULL, 786, 3, 1, NULL, NULL, 0, 0),
(619, '00:00', '00:00', '0', NULL, NULL, 786, 4, 1, NULL, NULL, 0, 0),
(620, '00:00', '00:00', '0', NULL, NULL, 786, 5, 1, NULL, NULL, 0, 0),
(621, '00:00', '00:00', '0', NULL, NULL, 786, 6, 1, NULL, NULL, 0, 0),
(622, '00:00', '00:00', '0', NULL, NULL, 786, 7, 1, NULL, NULL, 0, 0),
(623, '00:00', '00:00', '0', NULL, NULL, 786, 8, 1, NULL, NULL, 0, 0),
(624, '00:00', '00:00', '0', NULL, NULL, 786, 10, 1, NULL, NULL, 0, 0),
(625, '23:30', '47:01', '2', '2018-02-20', '2018-02-20', 787, 1, 3, '09:59:31', '10:46:32', 0, 0),
(626, '00:00', '00:00', '0', '2018-02-20', NULL, 787, 2, 4, '13:52:27', NULL, 0, 1),
(627, '00:00', '00:00', '0', NULL, NULL, 787, 3, 1, NULL, NULL, 0, 0),
(628, '00:00', '00:00', '0', NULL, NULL, 787, 4, 1, NULL, NULL, 0, 0),
(629, '00:00', '00:00', '0', NULL, NULL, 787, 5, 1, NULL, NULL, 0, 0),
(630, '00:00', '00:00', '0', NULL, NULL, 787, 6, 1, NULL, NULL, 0, 0),
(631, '00:00', '00:00', '0', NULL, NULL, 787, 7, 1, NULL, NULL, 0, 0),
(632, '00:00', '00:00', '0', NULL, NULL, 787, 8, 1, NULL, NULL, 0, 0),
(633, '00:00', '00:00', '0', NULL, NULL, 787, 9, 1, NULL, NULL, 0, 0),
(634, '00:00', '00:00', '0', NULL, NULL, 787, 10, 1, NULL, NULL, 0, 0),
(635, '00:00', '00:00', '0', '2018-02-20', NULL, 788, 1, 4, '14:13:02', NULL, 0, 1),
(636, '00:00', '00:00', '0', NULL, NULL, 788, 2, 1, NULL, NULL, 0, 0),
(637, '00:00', '00:00', '0', NULL, NULL, 788, 3, 1, NULL, NULL, 0, 0),
(638, '00:00', '00:00', '0', NULL, NULL, 788, 4, 1, NULL, NULL, 0, 0),
(639, '00:00', '00:00', '0', NULL, NULL, 788, 5, 1, NULL, NULL, 0, 0),
(640, '00:00', '00:00', '0', NULL, NULL, 788, 6, 1, NULL, NULL, 0, 0),
(641, '00:00', '00:00', '0', NULL, NULL, 788, 7, 1, NULL, NULL, 0, 0),
(642, '00:00', '00:00', '0', NULL, NULL, 788, 8, 1, NULL, NULL, 0, 0),
(643, '00:00', '00:00', '0', NULL, NULL, 788, 9, 1, NULL, NULL, 0, 0),
(644, '00:00', '00:00', '0', NULL, NULL, 788, 10, 1, NULL, NULL, 0, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_proyecto`
--

CREATE TABLE `detalle_proyecto` (
  `idDetalle_proyecto` int(11) NOT NULL,
  `tipo_negocio_idtipo_negocio` tinyint(4) NOT NULL,
  `canitadad_total` varchar(6) NOT NULL,
  `material` varchar(6) DEFAULT NULL,
  `proyecto_numero_orden` int(11) NOT NULL,
  `negocio_idnegocio` tinyint(4) NOT NULL,
  `estado_idestado` tinyint(4) NOT NULL,
  `PNC` tinyint(1) NOT NULL,
  `ubicacion` varchar(25) DEFAULT NULL,
  `pro_porIniciar` tinyint(10) DEFAULT '0',
  `pro_Ejecucion` tinyint(10) DEFAULT '0',
  `pro_Pausado` tinyint(10) DEFAULT '0',
  `pro_Terminado` tinyint(10) DEFAULT '0',
  `tiempo_total` varchar(20) DEFAULT NULL,
  `Total_timepo_Unidad` varchar(20) DEFAULT NULL,
  `fecha_salida` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `detalle_proyecto`
--

INSERT INTO `detalle_proyecto` (`idDetalle_proyecto`, `tipo_negocio_idtipo_negocio`, `canitadad_total`, `material`, `proyecto_numero_orden`, `negocio_idnegocio`, `estado_idestado`, `PNC`, `ubicacion`, `pro_porIniciar`, `pro_Ejecucion`, `pro_Pausado`, `pro_Terminado`, `tiempo_total`, `Total_timepo_Unidad`, `fecha_salida`) VALUES
(716, 1, '400', 'FV', 29697, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(717, 1, '200', 'FV', 29686, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(718, 1, '100', 'TH', 29698, 1, 1, 0, NULL, 10, 0, 0, 0, NULL, NULL, NULL),
(719, 7, '100', 'TH', 29673, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(720, 1, '12', 'TH', 29719, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(721, 1, '20', 'TH', 29694, 1, 1, 0, NULL, 10, 0, 0, 0, NULL, NULL, NULL),
(722, 1, '200', 'TH', 29571, 1, 1, 0, NULL, 10, 0, 0, 0, NULL, NULL, NULL),
(723, 1, '20', 'FV', 29656, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(724, 1, '3', 'TH', 29680, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(725, 1, '10', 'TH', 29674, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(726, 1, '200', 'FV', 29598, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(727, 1, '60', 'FV', 29652, 1, 2, 0, NULL, 2, 0, 0, 7, '191:58', NULL, NULL),
(728, 1, '68', 'TH', 29633, 1, 2, 0, NULL, 8, 0, 1, 1, '355:59', NULL, NULL),
(729, 1, '5', 'FV', 29695, 1, 1, 0, NULL, 8, 0, 0, 0, NULL, NULL, NULL),
(730, 1, '2', 'TH', 29687, 1, 1, 0, NULL, 10, 0, 0, 0, NULL, NULL, NULL),
(731, 1, '4', 'TH', 29691, 1, 2, 0, NULL, 4, 0, 0, 5, '312:57', NULL, NULL),
(732, 1, '2', 'TH', 29689, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(733, 7, '1', 'TH', 29665, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(734, 1, '35', 'TH', 29667, 1, 1, 0, NULL, 10, 0, 0, 0, NULL, NULL, NULL),
(735, 1, '150', 'FV', 29612, 1, 1, 0, NULL, 8, 0, 0, 0, NULL, NULL, NULL),
(736, 1, '100', 'FV', 29658, 1, 2, 0, NULL, 7, 0, 1, 0, '15:50', NULL, NULL),
(737, 1, '6', 'TH', 29688, 1, 1, 0, NULL, 10, 0, 0, 0, NULL, NULL, NULL),
(738, 1, '2', 'TH', 29713, 1, 1, 0, NULL, 10, 0, 0, 0, NULL, NULL, NULL),
(739, 1, '1', 'TH', 29690, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(740, 1, '100', 'TH', 29651, 1, 2, 0, NULL, 9, 0, 0, 1, '183:59', NULL, NULL),
(741, 1, '50', 'FV', 29677, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(742, 1, '1', 'TH', 29699, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(743, 7, '5', 'TH', 29684, 1, 2, 0, NULL, 6, 0, 0, 2, '288:40', NULL, NULL),
(744, 1, '1', 'TH', 29729, 1, 2, 0, NULL, 7, 0, 0, 2, '245:21', NULL, NULL),
(745, 1, '2', 'TH', 29723, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(746, 1, '10', 'TH', 29693, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(747, 1, '6', 'FV', 29725, 1, 1, 0, NULL, 8, 0, 0, 0, NULL, NULL, NULL),
(748, 1, '6', 'FV', 29724, 1, 1, 0, NULL, 8, 0, 0, 0, NULL, NULL, NULL),
(749, 1, '6', 'FV', 29722, 1, 2, 0, NULL, 4, 0, 0, 4, '133:51', NULL, NULL),
(750, 7, '60', 'FV', 29619, 1, 2, 0, NULL, 5, 0, 1, 2, '73:18', NULL, NULL),
(751, 1, '35', 'TH', 29683, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(752, 1, '50', 'TH', 29640, 1, 2, 0, NULL, 9, 0, 1, 0, '00:54', NULL, NULL),
(753, 1, '50', 'TH', 29681, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(754, 1, '20', 'FV', 29692, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(755, 1, '90', 'FV', 29676, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(756, 1, '10', 'TH', 29701, 1, 4, 0, NULL, 7, 1, 0, 1, '21:03', NULL, NULL),
(757, 1, '10', 'TH', 29715, 1, 4, 0, NULL, 7, 1, 0, 1, '49:41', NULL, NULL),
(758, 1, '200', 'FV', 29591, 1, 2, 0, NULL, 7, 0, 1, 1, '244:56', NULL, NULL),
(759, 1, '3', 'TH', 29635, 1, 2, 0, NULL, 5, 0, 0, 5, '377:49', NULL, NULL),
(760, 1, '2', 'TH', 29670, 1, 2, 0, NULL, 8, 0, 0, 1, '11:02', NULL, NULL),
(761, 1, '10', 'TH', 29730, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(762, 1, '10', 'TH', 29649, 1, 3, 0, NULL, 0, 0, 0, 9, '533:43', '53:20', '2018-02-16 14:06:08'),
(763, 1, '10', 'FV', 29752, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(764, 1, '4', 'TH', 29731, 1, 1, 0, NULL, 10, 0, 0, 0, NULL, NULL, NULL),
(765, 1, '8', 'FV', 29748, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(766, 7, '2', 'TH', 29700, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(767, 1, '20', 'FV', 29738, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(768, 1, '50', 'FV', 29743, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(769, 1, '20', 'TH', 29737, 1, 4, 0, NULL, 8, 1, 0, 1, '53:09', NULL, NULL),
(770, 1, '100', 'FV', 29739, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(771, 1, '100', 'FV', 29751, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(772, 1, '100', 'TH', 29749, 1, 1, 0, NULL, 10, 0, 0, 0, NULL, NULL, NULL),
(773, 1, '100', 'TH', 29750, 1, 1, 0, NULL, 10, 0, 0, 0, NULL, NULL, NULL),
(774, 7, '200', 'FV', 29746, 1, 1, 0, NULL, 8, 0, 0, 0, NULL, NULL, NULL),
(775, 4, '1', 'FV', 29742, 1, 3, 0, NULL, 0, 0, 0, 2, '46:17', '46:17', '2018-02-19 10:16:40'),
(776, 4, '1', 'FV', 29745, 1, 3, 0, NULL, 0, 0, 0, 2, '47:18', '47:18', '2018-02-19 10:15:37'),
(777, 4, '1', 'FV', 29746, 1, 3, 0, NULL, 0, 0, 0, 2, '49:15', '49:15', '2018-02-19 10:17:45'),
(778, 1, '30', 'TH', 29764, 1, 2, 0, NULL, 8, 0, 1, 1, '157:21', NULL, NULL),
(779, 1, '1', 'FV', 29765, 1, 2, 0, NULL, 3, 0, 0, 5, '71:55', NULL, NULL),
(780, 1, '2', 'TH', 29768, 1, 2, 0, NULL, 7, 0, 1, 1, '156:13', NULL, NULL),
(781, 1, '10', 'TH', 29727, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(782, 1, '10', 'TH', 29757, 1, 1, 0, NULL, 9, 0, 0, 0, NULL, NULL, NULL),
(783, 1, '2', 'TH', 29760, 1, 4, 0, NULL, 7, 1, 0, 1, '54:08', NULL, NULL),
(784, 1, '1', 'TH', 29761, 1, 4, 0, NULL, 7, 1, 0, 1, '54:21', NULL, NULL),
(785, 1, '1', 'TH', 29762, 1, 4, 0, NULL, 7, 1, 0, 1, '55:57', NULL, NULL),
(786, 1, '10', 'TH', 29716, 1, 4, 0, NULL, 7, 1, 0, 1, '54:16', NULL, NULL),
(787, 1, '2', 'TH', 29758, 1, 4, 0, NULL, 8, 1, 0, 1, '47:01', NULL, NULL),
(788, 1, '30', 'TH', 29764, 1, 4, 1, 'C.C.TH', 9, 1, 0, 0, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_teclados`
--

CREATE TABLE `detalle_teclados` (
  `idDetalle_teclados` smallint(6) NOT NULL,
  `tiempo_por_unidad` varchar(6) DEFAULT NULL,
  `tiempo_total_proceso` varchar(10) DEFAULT NULL,
  `cantidad_terminada` varchar(6) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `detalle_proyecto_idDetalle_proyecto` int(11) NOT NULL,
  `Procesos_idproceso` tinyint(4) NOT NULL,
  `estado_idestado` tinyint(4) NOT NULL,
  `hora_ejecucion` time DEFAULT NULL,
  `hora_terminacion` time DEFAULT NULL,
  `restantes` int(6) NOT NULL DEFAULT '0',
  `noperarios` tinyint(2) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_tipo_negocio_proceso`
--

CREATE TABLE `detalle_tipo_negocio_proceso` (
  `idproceso` tinyint(4) NOT NULL,
  `negocio_idnegocio` tinyint(4) NOT NULL,
  `idtipo_negocio` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estado`
--

CREATE TABLE `estado` (
  `idestado` tinyint(4) NOT NULL,
  `nombre` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `estado`
--

INSERT INTO `estado` (`idestado`, `nombre`) VALUES
(4, 'Ejecucion'),
(2, 'Pausado'),
(1, 'Por iniciar'),
(3, 'Terminado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `negocio`
--

CREATE TABLE `negocio` (
  `idnegocio` tinyint(4) NOT NULL,
  `nom_negocio` varchar(7) NOT NULL,
  `estado` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `negocio`
--

INSERT INTO `negocio` (`idnegocio`, `nom_negocio`, `estado`) VALUES
(1, 'FE', 1),
(2, 'TE', 1),
(3, 'IN', 1),
(4, 'ALMACEN', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `procesos`
--

CREATE TABLE `procesos` (
  `idproceso` tinyint(4) NOT NULL,
  `nombre_proceso` varchar(30) NOT NULL,
  `estado` tinyint(1) NOT NULL,
  `negocio_idnegocio` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `procesos`
--

INSERT INTO `procesos` (`idproceso`, `nombre_proceso`, `estado`, `negocio_idnegocio`) VALUES
(1, 'Perforado', 1, 1),
(2, 'Quimicos', 1, 1),
(3, 'Caminos', 1, 1),
(4, 'Quemado', 1, 1),
(5, 'C.C.TH', 1, 1),
(6, 'Screen', 1, 1),
(7, 'Estañado', 1, 1),
(8, 'C.C.2', 1, 1),
(9, 'Ruteo', 1, 1),
(10, 'Maquinas', 1, 1),
(11, 'Correas y Conversor', 1, 2),
(12, 'Lexan', 1, 2),
(13, 'Acople', 1, 2),
(14, 'Control calidad', 1, 2),
(15, 'Manual', 1, 3),
(16, 'Automatico', 1, 3),
(17, 'Control Calidad', 1, 3),
(18, 'Empaque', 1, 3),
(19, 'Componentes', 1, 4),
(20, 'GF', 1, 4),
(24, 'prueba', 0, 3),
(25, 'demostracion', 1, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyecto`
--

CREATE TABLE `proyecto` (
  `numero_orden` int(11) NOT NULL,
  `usuario_numero_documento` varchar(13) NOT NULL,
  `nombre_cliente` varchar(150) DEFAULT NULL,
  `nombre_proyecto` varchar(150) DEFAULT NULL,
  `tipo_proyecto` varchar(6) DEFAULT NULL,
  `FE` tinyint(1) NOT NULL,
  `TE` tinyint(1) NOT NULL,
  `IN` tinyint(1) NOT NULL,
  `pcb_FE` tinyint(1) NOT NULL,
  `pcb_TE` tinyint(1) NOT NULL,
  `Conversor` tinyint(1) NOT NULL,
  `Repujado` tinyint(1) NOT NULL,
  `troquel` tinyint(1) NOT NULL,
  `stencil` tinyint(1) NOT NULL,
  `lexan` tinyint(1) NOT NULL,
  `fecha_ingreso` datetime NOT NULL,
  `fecha_entrega` date DEFAULT NULL,
  `fecha_salidal` datetime DEFAULT NULL,
  `ruteoC` tinyint(1) DEFAULT NULL,
  `antisolderC` tinyint(1) DEFAULT NULL,
  `estado_idestado` tinyint(4) NOT NULL,
  `antisolderP` tinyint(1) DEFAULT NULL,
  `ruteoP` tinyint(1) DEFAULT NULL,
  `eliminacion` tinyint(1) DEFAULT '1',
  `parada` tinyint(1) DEFAULT '1',
  `entregaCircuitoFEoGF` date DEFAULT NULL,
  `entregaCOMCircuito` date DEFAULT NULL,
  `entregaPCBFEoGF` date DEFAULT NULL,
  `entregaPCBCom` date DEFAULT NULL,
  `novedades` varchar(250) DEFAULT NULL,
  `estadoEmpresa` varchar(13) DEFAULT NULL,
  `NFEE` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `proyecto`
--

INSERT INTO `proyecto` (`numero_orden`, `usuario_numero_documento`, `nombre_cliente`, `nombre_proyecto`, `tipo_proyecto`, `FE`, `TE`, `IN`, `pcb_FE`, `pcb_TE`, `Conversor`, `Repujado`, `troquel`, `stencil`, `lexan`, `fecha_ingreso`, `fecha_entrega`, `fecha_salidal`, `ruteoC`, `antisolderC`, `estado_idestado`, `antisolderP`, `ruteoP`, `eliminacion`, `parada`, `entregaCircuitoFEoGF`, `entregaCOMCircuito`, `entregaPCBFEoGF`, `entregaPCBCom`, `novedades`, `estadoEmpresa`, `NFEE`) VALUES
(29571, '981130', 'sistemas sentry', 'snt013', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 06:50:45', '2018-02-13', NULL, 1, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29591, '981130', 'sistemas sentry', 'snt013', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:44:23', '2018-02-13', NULL, 1, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29598, '981130', 'inadisa', 'foto 22A', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 06:54:31', '2018-02-14', NULL, 1, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29612, '981130', 'MAURICIO VASCO -OPTEC', 'TECNOP2', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:04:06', '2018-02-15', NULL, 1, 0, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29619, '981130', 'SERVICIOS INDUSTRIALES', 'TECLADO --TECLADO T8019', 'Normal', 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, '2018-02-15 07:17:43', '2018-02-20', NULL, 0, 0, 2, 0, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29633, '981130', 'casas automaticas ltda', 'CA_RFB_WIFI_V1_0', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 06:56:31', '2018-02-14', NULL, 1, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29635, '981130', 'apolo system', 'misi-E-1.0', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:56:28', '2018-02-12', NULL, 1, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29640, '981130', 'EFFITECH SAS', 'INTERFACE PIC V2.0', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:19:47', '2018-02-20', NULL, 1, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29649, '981130', 'diseven innovacion tecnologica sas', 'infrarrojo v5', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 09:30:04', '2018-02-09', '2018-02-16 14:06:08', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29651, '981130', 'NETXUT SAS', 'NXLAMP 2.0', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:08:14', '2018-02-16', NULL, 1, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29652, '981130', 'alejando saldarriaga ochoa', 'Reflector antena helica 5.8', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 06:55:22', '2018-02-14', NULL, 1, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29656, '981130', 'sucofer s.a.s', 'proyecto sucofer', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 06:51:55', '2018-02-13', NULL, 1, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29658, '981130', 'MAURICO VASCO -OPTEC', '75DCB2', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:04:48', '2018-02-15', NULL, 1, 0, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29665, '981130', 'BASYBAL SAS', 'TECLADO--TECLADO SARTORIUS', 'Normal', 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, '2018-02-15 07:02:01', '2018-02-15', NULL, 0, 0, 1, 0, 1, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29667, '981130', 'FABIAN ENRIQUEZ URIBE', 'GENIAL MODULOT PWC5', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:03:07', '2018-02-15', NULL, 1, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29670, '981130', 'alexander arboleda gomez', 'control de EFT', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 08:19:14', '2018-02-12', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29673, '981130', 'industias orbident de colombia', 'teclado--teclado_tmp', 'Normal', 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, '2018-02-15 06:46:14', '2018-02-23', NULL, 0, 0, 1, 0, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29674, '981130', 'insa SAS', 'BB tag', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 06:53:44', '2018-02-14', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29676, '981130', 'SISTEMAS SENTRY', 'CONTROLCENTRAL_USB', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:22:20', '2018-02-20', NULL, 1, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29677, '981130', 'TEX CHUPA', 'TAXIMETRO_CHUPA', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:09:08', '2018-02-16', NULL, 1, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29680, '981130', 'dshay tech s.a.s', 'proyecto didactico', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 06:52:52', '2018-02-14', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29681, '981130', 'MAURICIO VASCO -OPTEC', '90DC', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:20:41', '2018-02-20', NULL, 1, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29683, '981130', 'MAURICIO VASCO -OPTEC', '90AC-V2', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:19:01', '2018-02-20', NULL, 1, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29684, '981130', 'AXEL LTDA', 'TECLADO --TECLADO MEDIDOR', 'Normal', 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, '2018-02-15 07:10:39', '2018-02-16', NULL, 0, 0, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29686, '981130', 'taximetro george medellin', 'termocard3dig_vel_cooler', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 06:42:55', '2018-02-28', NULL, 1, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29687, '981130', 'lumind SAS', 'FUENTE 12-24', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 06:58:51', '2018-02-14', NULL, 1, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29688, '981130', 'LUMIND SAS', 'BAL2CH1MICRO', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:05:43', '2018-02-15', NULL, 1, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29689, '981130', 'GASOLUTIONS SAS', 'INTERFACE PCB MAX232 V2.0', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:01:01', '2018-02-14', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29690, '981130', 'SEGUNDO CICLO', 'FCONTROLLER_V2', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:07:25', '2018-02-15', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29691, '981130', 'DUKENET SAS', 'CHARGELIGTH', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 06:59:46', '2018-02-14', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29692, '981130', 'UNIVERSIDAD EAFIT', 'FUENTE 12V Y 5V', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:21:25', '2018-02-20', NULL, 1, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29693, '981130', 'UNIVERSIDAD EAFIT', 'MAQUETAMOTOR', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:13:34', '2018-02-19', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29694, '981130', 'usuga araqu elmer antonio', 'maqutasmaforo', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 06:49:02', '2018-02-21', NULL, 1, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29695, '981130', 'universidad eafit', 'compuertas', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 06:57:26', '2018-02-14', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29697, '981130', 'netxus s.a.s', 'miwishield', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 06:40:55', '2018-03-07', NULL, 1, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29698, '981130', 'netxus s.a.s', 'switch c&k', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 06:44:21', '2018-02-23', NULL, 1, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29699, '981130', 'ACCESO VIRTUAL SAS', 'PROBADOR PLACA', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:09:48', '2018-02-16', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29700, '981130', 'SOFTWARE E INSTRUMENTACION SAS', 'TECLADO -- TECLADO DE CONTROL', 'Normal', 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, '2018-02-19 06:17:27', '2018-02-22', NULL, 0, 0, 1, 0, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29701, '981130', 'NOVA CONTROL SAS', 'ADQUISICIONDEDATOS_CDA_MOTOS_V2', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:23:25', '2018-02-20', NULL, 0, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29713, '981130', 'UNIVERSIDAD PONTIFICIA BOLIVARIANA', 'BIO_EMG_BOARD_ADQUISICION_V4', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:06:41', '2018-02-15', NULL, 1, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29715, '981130', 'GOTTA SAS', 'VENDING VERSION 5_1', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:24:11', '2018-02-20', NULL, 0, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29716, '981130', 'GOTTA SAS', 'CIRCUITO DISPLAY', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-20 09:31:29', '2018-02-23', NULL, 0, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29719, '981130', 'universidad eafit', 'impreso', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 06:47:33', '2018-02-21', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29722, '981130', 'BIOMEDIK GROUP SAS', 'CNTRL_DIG_MINI_V3_02_2018', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:16:38', '2018-02-19', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29723, '981130', 'JULIO VICENTE GORDILLO SAAVEDRA', 'CONTROLADOR DE CORRIENTE', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:12:28', '2018-02-16', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29724, '981130', 'BIOMEDIK GROUP SAS', 'RF_FUENTE_V1_11_2016', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:15:47', '2018-02-19', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29725, '981130', 'BIOMEDIK GROUP SAS', 'RF_POTENCIA_V11_05_2017', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:14:37', '2018-02-19', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29727, '981130', 'TECNOTIUM SAS', 'ADC_PIC18F_PIC12(20181)', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-20 09:03:47', '2018-02-23', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29729, '981130', 'PIPELINE GAUGE SERVICIOS ENGINEERING', 'CARD_001', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 07:11:34', '2018-02-16', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29730, '981130', 'diseven innovacion tecnologica SAS', 'infrarrojo v5', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-15 09:28:42', '2018-02-09', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29731, '981130', 'PIPELINE GAUGE SERVICES ENGINEERING', 'FLUX_DETECTOR', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-19 06:14:52', '2018-02-21', NULL, 1, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29737, '981130', 'KNOW HOW', 'PCB 01', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-19 06:19:48', '2018-02-23', NULL, 1, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29738, '981130', 'KNOW HOW', 'PCB 02', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-19 06:18:20', '2018-02-22', NULL, 1, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29739, '981130', 'NETUX SAS', 'NXSTATUS CON PANTALL', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-19 06:21:34', '2018-02-26', NULL, 1, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29742, '981130', 'NETUX SAS', 'LEXAN --LEXAN NXSTATUS CON PANTALL', 'Normal', 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, '2018-02-19 06:27:42', '2018-02-19', '2018-02-19 10:16:40', 0, 0, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29743, '981130', 'UNIVERSIDAD POPILAR DEL CESAR', 'ALDig', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-19 06:19:06', '2018-02-22', NULL, 1, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29745, '981130', 'NETUX SAS', 'LEXAN --LEXAN NX GATEWAY', 'Normal', 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, '2018-02-19 06:28:46', '2018-02-19', '2018-02-19 10:15:37', 0, 0, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29746, '981130', 'NETUX SAS', 'TECLADO --TECLADO TM456', 'Normal', 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, '2018-02-19 06:26:12', '2018-03-08', NULL, 0, 0, 2, 0, 1, 1, 1, NULL, NULL, NULL, NULL, 'null', 'A tiempo', NULL),
(29748, '981130', 'DEMO INGENIERIA LTDA', '34-cruAux', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-19 06:15:52', '2018-02-21', NULL, 1, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29749, '981130', 'NETUX SAS', 'NXCALL 3.1REV3', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-19 06:24:00', '2018-03-01', NULL, 1, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29750, '981130', 'NETUX SAS', 'NXLAMP 2.0', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-19 06:24:50', '2018-03-01', NULL, 1, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29751, '981130', 'SOFTWARE E INSTRUMENNTACION SAS', 'BASIC CONTROL V_5.0', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-19 06:22:32', '2018-02-27', NULL, 1, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29752, '981130', 'SYTEMS AND SERVICES GROUP SAS (SSG AC SAS)', 'PURIFICADOR RGB', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-19 06:13:33', '2018-02-21', NULL, 1, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29757, '981130', 'DIEGO ALEJANRO RIVERA CASTAÑEDA', 'TRIFASICO', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-20 09:05:33', '2018-02-26', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29758, '981130', 'FUTURE SOLUTIONS DEVELOMENT SAS', 'GERBER_FSD_002_ETHER', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-20 09:59:03', '2018-02-21', NULL, 1, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29760, '981130', 'FUTURE SOLUTIONS DEVELOPMENT SAS', 'GERBER_FSD_03_ETHER', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-20 09:26:46', '2018-02-21', NULL, 0, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29761, '981130', 'OVO TECHNOLOGIES SAS', 'DISPARADOR IGBT FINAL SIN DIVISOR', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-20 09:28:07', '2018-02-21', NULL, 0, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29762, '981130', 'OVO TCHNOLOGIES SAS', 'DIVISOR DE TENSION', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-20 09:29:25', '2018-02-21', NULL, 0, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29764, '981130', 'LOGSENT DOSQUEBRADAS', 'CELOTOR_reader3', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-19 11:08:00', '2018-02-22', NULL, 1, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29765, '981130', 'POWERSUN LTDA', 'ALTIUM QYC', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-19 13:08:06', '2018-02-19', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(29768, '981130', 'UNIVERSIDAD NACIONAL DE COLOMBIA', 'SENoseNH3C2', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-02-19 13:39:38', '2018-02-19', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_negocio`
--

CREATE TABLE `tipo_negocio` (
  `idtipo_negocio` tinyint(4) NOT NULL,
  `nombre` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tipo_negocio`
--

INSERT INTO `tipo_negocio` (`idtipo_negocio`, `nombre`) VALUES
(1, 'Circuito'),
(2, 'Conversor'),
(3, 'Repujado'),
(4, 'Troquel'),
(5, 'Teclado'),
(6, 'Stencil'),
(7, 'PCB'),
(8, 'Circuito GF'),
(9, 'PCB GF'),
(10, 'Circuito COM'),
(11, 'PCB COM'),
(12, 'Circuito-TE');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `numero_documento` varchar(13) NOT NULL,
  `tipo_documento` varchar(3) NOT NULL,
  `nombres` varchar(30) NOT NULL,
  `apellidos` varchar(30) DEFAULT NULL,
  `cargo_idcargo` tinyint(4) NOT NULL,
  `imagen` varchar(250) DEFAULT NULL,
  `estado` tinyint(1) NOT NULL,
  `contraeña` varchar(20) NOT NULL,
  `sesion` tinyint(1) DEFAULT '0',
  `recuperacion` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`numero_documento`, `tipo_documento`, `nombres`, `apellidos`, `cargo_idcargo`, `imagen`, `estado`, `contraeña`, `sesion`, `recuperacion`) VALUES
('109999999', 'CC', 'juan andresa', 'asdasd', 1, NULL, 1, '109999999', 0, 'citg9j-x56'),
('1216727814', 'CC', 'jhon jairo ', 'sanchez correa', 1, NULL, 1, '1216727814', 0, 'x1ññwula2y'),
('1216727816', 'CC', 'juan david', 'marulanda p', 3, '', 1, '98113053240juan', 0, 'wn-gd7c@5q'),
('3004991084', 'CE', 'fredy', 'velez', 1, NULL, 1, '3004991084', 0, '8uifbgjxq1'),
('981130', 'CC', 'sivia hortensia', 'paniagua gomez', 4, '', 1, '981130', 1, '1u-hyppy60'),
('98113053', 'CC', 'Catalina', ' rosario', 1, NULL, 0, '98113053', 0, 'bo3t-amybñ'),
('98113053240', 'CC', 'juan david ', 'marulitoo', 5, NULL, 1, '98113053240', 0, 'i0s2ienq6p'),
('9813053240', 'CC', 'Juan David ', 'Marulanda Paniagua', 2, '', 1, '9813053240', 1, '-8qa2-x54h'),
('99120101605', 'CC', 'sadasd', 'juan andres', 1, NULL, 1, '99120101605', 0, 'ptaeh3a0ab');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuariopuerto`
--

CREATE TABLE `usuariopuerto` (
  `documentousario` varchar(13) CHARACTER SET utf8 DEFAULT NULL,
  `usuarioPuerto` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuariopuerto`
--

INSERT INTO `usuariopuerto` (`documentousario`, `usuarioPuerto`) VALUES
('981130', 'COM2'),
('9813053240', 'COM3');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `almacen`
--
ALTER TABLE `almacen`
  ADD PRIMARY KEY (`idalmacen`),
  ADD KEY `fk_iddetalleproyecto_amacen` (`detalle_proyecto_idDetalle_proyecto`),
  ADD KEY `fk_idestado_amacen` (`estado_idestado`),
  ADD KEY `fk_proceso_id` (`Procesos_idproceso`);

--
-- Indices de la tabla `cargo`
--
ALTER TABLE `cargo`
  ADD PRIMARY KEY (`idcargo`);

--
-- Indices de la tabla `detalle_ensamble`
--
ALTER TABLE `detalle_ensamble`
  ADD PRIMARY KEY (`idDetalle_ensamble`,`detalle_proyecto_idDetalle_proyecto`,`Procesos_idproceso`,`estado_idestado`),
  ADD KEY `fk_detalle_teclados_detalle_proyecto1_idx` (`detalle_proyecto_idDetalle_proyecto`),
  ADD KEY `fk_detalle_ensamble_Procesos1_idx` (`Procesos_idproceso`),
  ADD KEY `fk_detalle_ensamble_estado1_idx` (`estado_idestado`);

--
-- Indices de la tabla `detalle_formato_estandar`
--
ALTER TABLE `detalle_formato_estandar`
  ADD PRIMARY KEY (`idDetalle_formato_estandar`,`detalle_proyecto_idDetalle_proyecto`,`Procesos_idproceso`,`estado_idestado`),
  ADD KEY `fk_detalle_formato_estandar_detalle_proyecto1_idx` (`detalle_proyecto_idDetalle_proyecto`),
  ADD KEY `fk_detalle_formato_estandar_Procesos1_idx` (`Procesos_idproceso`),
  ADD KEY `fk_detalle_formato_estandar_estado1_idx` (`estado_idestado`);

--
-- Indices de la tabla `detalle_proyecto`
--
ALTER TABLE `detalle_proyecto`
  ADD PRIMARY KEY (`idDetalle_proyecto`,`tipo_negocio_idtipo_negocio`,`proyecto_numero_orden`,`negocio_idnegocio`,`estado_idestado`),
  ADD KEY `fk_detalle_proyecto_proyecto1_idx` (`proyecto_numero_orden`),
  ADD KEY `fk_detalle_proyecto_tipo_negocio1_idx` (`tipo_negocio_idtipo_negocio`),
  ADD KEY `fk_detalle_proyecto_negocio1_idx` (`negocio_idnegocio`),
  ADD KEY `fk_detalle_proyecto_estado1_idx` (`estado_idestado`);

--
-- Indices de la tabla `detalle_teclados`
--
ALTER TABLE `detalle_teclados`
  ADD PRIMARY KEY (`idDetalle_teclados`,`detalle_proyecto_idDetalle_proyecto`,`Procesos_idproceso`,`estado_idestado`),
  ADD KEY `fk_detalle_teclados_detalle_proyecto1_idx` (`detalle_proyecto_idDetalle_proyecto`),
  ADD KEY `fk_detalle_teclados_Procesos1_idx` (`Procesos_idproceso`),
  ADD KEY `fk_detalle_teclados_estado1_idx` (`estado_idestado`);

--
-- Indices de la tabla `detalle_tipo_negocio_proceso`
--
ALTER TABLE `detalle_tipo_negocio_proceso`
  ADD PRIMARY KEY (`idproceso`,`negocio_idnegocio`,`idtipo_negocio`),
  ADD KEY `fk_Procesos_has_tipo_negocio_tipo_negocio1_idx` (`idtipo_negocio`),
  ADD KEY `fk_Procesos_has_tipo_negocio_Procesos1_idx` (`idproceso`,`negocio_idnegocio`);

--
-- Indices de la tabla `estado`
--
ALTER TABLE `estado`
  ADD PRIMARY KEY (`idestado`),
  ADD UNIQUE KEY `nombre_UNIQUE` (`nombre`);

--
-- Indices de la tabla `negocio`
--
ALTER TABLE `negocio`
  ADD PRIMARY KEY (`idnegocio`);

--
-- Indices de la tabla `procesos`
--
ALTER TABLE `procesos`
  ADD PRIMARY KEY (`idproceso`,`negocio_idnegocio`),
  ADD KEY `fk_Procesos_negocio1_idx` (`negocio_idnegocio`);

--
-- Indices de la tabla `proyecto`
--
ALTER TABLE `proyecto`
  ADD PRIMARY KEY (`numero_orden`,`usuario_numero_documento`,`estado_idestado`),
  ADD UNIQUE KEY `numero_orden_UNIQUE` (`numero_orden`),
  ADD KEY `fk_proyecto_usuario_idx` (`usuario_numero_documento`),
  ADD KEY `fk_proyecto_estado1_idx` (`estado_idestado`);

--
-- Indices de la tabla `tipo_negocio`
--
ALTER TABLE `tipo_negocio`
  ADD PRIMARY KEY (`idtipo_negocio`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`numero_documento`,`cargo_idcargo`),
  ADD UNIQUE KEY `numero_documento_UNIQUE` (`numero_documento`),
  ADD KEY `fk_usuario_cargo1_idx` (`cargo_idcargo`);

--
-- Indices de la tabla `usuariopuerto`
--
ALTER TABLE `usuariopuerto`
  ADD KEY `fk_usuario_puerto1` (`documentousario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `almacen`
--
ALTER TABLE `almacen`
  MODIFY `idalmacen` smallint(6) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cargo`
--
ALTER TABLE `cargo`
  MODIFY `idcargo` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `detalle_ensamble`
--
ALTER TABLE `detalle_ensamble`
  MODIFY `idDetalle_ensamble` smallint(6) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalle_formato_estandar`
--
ALTER TABLE `detalle_formato_estandar`
  MODIFY `idDetalle_formato_estandar` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=645;

--
-- AUTO_INCREMENT de la tabla `detalle_proyecto`
--
ALTER TABLE `detalle_proyecto`
  MODIFY `idDetalle_proyecto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=789;

--
-- AUTO_INCREMENT de la tabla `detalle_teclados`
--
ALTER TABLE `detalle_teclados`
  MODIFY `idDetalle_teclados` smallint(6) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `estado`
--
ALTER TABLE `estado`
  MODIFY `idestado` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `negocio`
--
ALTER TABLE `negocio`
  MODIFY `idnegocio` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `procesos`
--
ALTER TABLE `procesos`
  MODIFY `idproceso` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de la tabla `proyecto`
--
ALTER TABLE `proyecto`
  MODIFY `numero_orden` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29769;

--
-- AUTO_INCREMENT de la tabla `tipo_negocio`
--
ALTER TABLE `tipo_negocio`
  MODIFY `idtipo_negocio` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `almacen`
--
ALTER TABLE `almacen`
  ADD CONSTRAINT `fk_iddetalleproyecto_amacen` FOREIGN KEY (`detalle_proyecto_idDetalle_proyecto`) REFERENCES `detalle_proyecto` (`idDetalle_proyecto`),
  ADD CONSTRAINT `fk_idestado_amacen` FOREIGN KEY (`estado_idestado`) REFERENCES `estado` (`idestado`),
  ADD CONSTRAINT `fk_proceso_id` FOREIGN KEY (`Procesos_idproceso`) REFERENCES `procesos` (`idproceso`);

--
-- Filtros para la tabla `detalle_ensamble`
--
ALTER TABLE `detalle_ensamble`
  ADD CONSTRAINT `fk_detalle_ensamble_Procesos1` FOREIGN KEY (`Procesos_idproceso`) REFERENCES `procesos` (`idproceso`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_ensamble_estado1` FOREIGN KEY (`estado_idestado`) REFERENCES `estado` (`idestado`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_teclados_detalle_proyecto10` FOREIGN KEY (`detalle_proyecto_idDetalle_proyecto`) REFERENCES `detalle_proyecto` (`idDetalle_proyecto`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `detalle_formato_estandar`
--
ALTER TABLE `detalle_formato_estandar`
  ADD CONSTRAINT `fk_detalle_formato_estandar_Procesos1` FOREIGN KEY (`Procesos_idproceso`) REFERENCES `procesos` (`idproceso`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_formato_estandar_detalle_proyecto1` FOREIGN KEY (`detalle_proyecto_idDetalle_proyecto`) REFERENCES `detalle_proyecto` (`idDetalle_proyecto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_formato_estandar_estado1` FOREIGN KEY (`estado_idestado`) REFERENCES `estado` (`idestado`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `detalle_proyecto`
--
ALTER TABLE `detalle_proyecto`
  ADD CONSTRAINT `fk_detalle_proyecto_estado1` FOREIGN KEY (`estado_idestado`) REFERENCES `estado` (`idestado`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_proyecto_negocio1` FOREIGN KEY (`negocio_idnegocio`) REFERENCES `negocio` (`idnegocio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_proyecto_proyecto1` FOREIGN KEY (`proyecto_numero_orden`) REFERENCES `proyecto` (`numero_orden`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_proyecto_tipo_negocio1` FOREIGN KEY (`tipo_negocio_idtipo_negocio`) REFERENCES `tipo_negocio` (`idtipo_negocio`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `detalle_teclados`
--
ALTER TABLE `detalle_teclados`
  ADD CONSTRAINT `fk_detalle_teclados_Procesos1` FOREIGN KEY (`Procesos_idproceso`) REFERENCES `procesos` (`idproceso`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_teclados_detalle_proyecto1` FOREIGN KEY (`detalle_proyecto_idDetalle_proyecto`) REFERENCES `detalle_proyecto` (`idDetalle_proyecto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_teclados_estado1` FOREIGN KEY (`estado_idestado`) REFERENCES `estado` (`idestado`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `detalle_tipo_negocio_proceso`
--
ALTER TABLE `detalle_tipo_negocio_proceso`
  ADD CONSTRAINT `fk_Procesos_has_tipo_negocio_Procesos1` FOREIGN KEY (`idproceso`,`negocio_idnegocio`) REFERENCES `procesos` (`idproceso`, `negocio_idnegocio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Procesos_has_tipo_negocio_tipo_negocio1` FOREIGN KEY (`idtipo_negocio`) REFERENCES `tipo_negocio` (`idtipo_negocio`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `procesos`
--
ALTER TABLE `procesos`
  ADD CONSTRAINT `fk_Procesos_negocio1` FOREIGN KEY (`negocio_idnegocio`) REFERENCES `negocio` (`idnegocio`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `proyecto`
--
ALTER TABLE `proyecto`
  ADD CONSTRAINT `fk_proyecto_estado1` FOREIGN KEY (`estado_idestado`) REFERENCES `estado` (`idestado`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_proyecto_usuario` FOREIGN KEY (`usuario_numero_documento`) REFERENCES `usuario` (`numero_documento`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `fk_usuario_cargo1` FOREIGN KEY (`cargo_idcargo`) REFERENCES `cargo` (`idcargo`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `usuariopuerto`
--
ALTER TABLE `usuariopuerto`
  ADD CONSTRAINT `fk_usuario_puerto1` FOREIGN KEY (`documentousario`) REFERENCES `usuario` (`numero_documento`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
