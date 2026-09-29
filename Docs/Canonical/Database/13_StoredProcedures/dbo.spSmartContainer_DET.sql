SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spSmartContainer_DET]
(
		@Num_Proc	Varchar(16)
)

as

select 
	[dbo].[Qty_Container](num_proc_hem) QtyC, cd_smart,nome_tp_cont,
	(case when num_cont_em = '__________-_' then '' else num_cont_em end) num_cont, 
	num_lacre_em num_lacre, Lacre_02_EM Num_Lacre_02,
	convert(datetime,Dt_Vcto_Devol_EM,105) Dt_Vcto_Devol_EM,CAI.Peso_Bruto_EM_VGM, CAI.UOM_VGM, CAI.Dt_Envio_VGM,
	CAI.Nome_Responsavel_VGM, CAI.Metodo_VGM,
	'FULL CONTAINER' EquipmentStatus,
	'CARRIER SUPPLIED' TypeofService
from container_mas_exp_mar CM with(nolock)
Join Tipo_container Tc with(nolock) on tc.cd_tp_cont=cm.cd_tp_cont
Join container_hou_exp_mar ch with(nolock) on ch.num_proc_mem=cm.num_proc_mem and ch.item_cont_em=cm.item_cont_em
left join Container_Additional_Info CAI with(nolock) on CH.Num_Proc_HEM = CAI.num_proc 
	and CAI.num_cont = replace(CM.num_cont_em,'-','') and ativo = 1
 where 
	num_proc_hem= @Num_Proc
							





GO
