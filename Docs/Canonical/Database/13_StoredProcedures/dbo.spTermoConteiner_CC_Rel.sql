SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spTermoConteiner_CC_Rel]--'IMCSR20090206401'
(
@processo as varchar(16)
)
As	
	select				
		CMM.Num_cont_IM									Conteiner,		
		TPC.nome_tp_cont					tipo		
	from				
		container_hou_imp_mar CCM
		left join container_mas_imp_mar		CMM	on CMM.item_cont_im = CCM.item_cont_im  and CCM.num_proc_mim=CMM.num_proc_mim
		left join tipo_container			TPC on TPC.cd_tp_cont = CMM.cd_tp_cont 
	where
		CCM.Num_Proc_HIM = @processo

GO
