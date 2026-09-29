SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[dbo].[sp301_Equipment_Sel]'EMCSR202209103BR'
--cadu 04/10/2022 - ALterado p enviar a qtde recebida, nao sei se esta correto
CREATE Procedure [dbo].[sp301_Equipment_Sel]
	@Num_Proc	varchar(16)
	
as

select distinct
	--EquipmentQuantity.Campo_Dados EquipmentQuantity,
	(case when EquipmentQuantity.Campo_Dados ='' or EquipmentQuantity.Campo_Dados is null then '1' else EquipmentQuantity.Campo_Dados end) EquipmentQuantity,
	--'1' EquipmentQuantity,
	EquipmentSize.Campo_Dados EquipmentSize,
	EquipmentType.Campo_Dados EquipmentType,
	tc.Nome_Tp_Carga cd_tp_cont	
  from Pedido_Ship PS  with(nolock)
join vwHouse_Exp LLP on LLP.Num_Proc = PS.Num_Proc
left join Tipo_Carga TC on TC.Cd_Tp_Carga = llp.Cd_Tp_Carga
Join campo_ordem EquipmentQuantity with(nolock) on PS.cd_pedido=EquipmentQuantity.cd_pedido and EquipmentQuantity.id_campo = 23
Join campo_ordem EquipmentSize with(nolock) on PS.cd_pedido=EquipmentSize.cd_pedido and EquipmentSize.id_campo = 24
Join campo_ordem EquipmentType with(nolock) on PS.cd_pedido=EquipmentType.cd_pedido and EquipmentType.id_campo = 25
Where 
	ps.Num_Proc=@Num_Proc

--23	10017	S	EquipmentQuantity
--24	10017	S	EquipmentSize
--25	10017	S	EquipmentType


GO
