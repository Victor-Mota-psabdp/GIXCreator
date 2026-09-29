SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure spATL_Pedido_Container_Sel
(
@Cd_Pedido int
)
as

select 
	Num_Cont , 
	Num_Lacre,
	Peso_Bruto_VGM, 
	UOM_VGM, 
	Dt_Envio_VGM,
	Nome_Responsavel_VGM,
	(Case when metodo_vgm = 1 then '1-Weighing Packed Container'else  Case when metodo_vgm = 2 then '2-Weighing All Packages and Cargo Items' else '' End End)Metodo_VGM
from 
	Pedido_Container
where Cd_Pedido = @Cd_Pedido
GO
