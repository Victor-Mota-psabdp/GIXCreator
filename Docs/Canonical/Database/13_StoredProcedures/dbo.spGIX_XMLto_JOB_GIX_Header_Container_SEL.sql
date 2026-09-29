SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spGIX_XMLto_JOB_GIX_Header_Container_SEL]--46
	@ID_Req as BigInt
as

Select
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	CC.EquipmentInitial+CC.EquipmentNumber		[Num_Cont],
	CC.SealNumber								[Lacre],
	--(Case when left(CC.EquipmentType,2) = '20' then '20ft - Dry Van'	
	--else '40ft - Dry Van'	end)				[Nome_Tp_Cont],
	(Case when left(CC.EquipmentType,2) = '20' then '20ft - Dry Van'
		else
	(Case when EquipmentType = 'ISO20' then '20ft - ISO Tank'
		else
	(Case when EquipmentType = 'ISO40' then '40ft - ISO TANK'	
		else '40ft - Dry Van'	end)end)end)	[Nome_Tp_Cont],
	PesoBruto.MeasurementValue					[Peso_Bruto],
	
	'ATL System'								[Usuario],
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join vwALL_JOBs V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	join ATL_INT.dbo.GIX_Header_Equipment CC on CC.ID_Req = Request.ID_Req	
	join ATL_INT.dbo.GIX_Footer_Measurements PesoBruto on PesoBruto.ID_Req = Request.ID_Req
	and PesoBruto.item = 'GrossWeightKilograms'	
	Left Join Container_Hou_Imp_Mar HOU with(nolock) on HOu.Num_Proc_HIM = V.Num_Proc
	left join container_mas_imp_mar MAS with(nolock) on MAS.Num_Proc_MIM = HOU.Num_Proc_MIM and MAS.Item_Cont_IM = HOU.Item_Cont_IM	
Where
	Request.ID_Req = @ID_Req
	and CC.EquipmentInitial is not null 
	and MAS.Num_Cont_IM is null
	
	

GO
