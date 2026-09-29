SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from tipo_taxa where LEFT(CD_TP_tX,2)='XB'
--select * from grupo_taxa

 
CREATE function [dbo].[FBusca_Adto](
			@Num_Proc Varchar(16)
			
			
		)returns Datetime
AS 

BEGIN
	Declare @Valor Datetime
	if LEFT(@NUM_PROC,2)='IM'
		BEGIN
			set @valor=(
				select top 1 convert(datetime,dt_ins_him,105) from cta_ctE_hou_imp_mar CTA with(nolock)
				join tipo_taxa TT with(nolock) on TT.cd_tp_tx = CTA.cd_tp_tx
				Where num_proc_him=@num_proc and TT.ref_ctb_tx = 'ADT'
				--AND LEFT(CD_TP_tX,2)='XB'
				order by convert(datetime,dt_ins_him,105) desc
				)
		END
	if LEFT(@NUM_PROC,2)='IO'
		BEGIN
			set @valor=(
				select top 1 convert(datetime,dt_ins_hio,105) from cta_ctE_hou_imp_out CTA with(nolock)
				join tipo_taxa TT with(nolock) on TT.cd_tp_tx = CTA.cd_tp_tx
				Where num_proc_hio=@num_proc and TT.ref_ctb_tx = 'ADT'
				--AND LEFT(CD_TP_tX,2)='XB'
				order by convert(datetime,dt_ins_hio,105) desc
				)
		
		END
	if LEFT(@NUM_PROC,2)='IA'
		BEGIN
			set @valor=(
				select top 1 convert(datetime,dt_ins_hia,105) from cta_ctE_hou_imp_aer CTA with(nolock)
				join tipo_taxa TT with(nolock) on TT.cd_tp_tx = CTA.cd_tp_tx
				Where num_proc_hia=@num_proc and TT.ref_ctb_tx = 'ADT'
				--AND LEFT(CD_TP_tX,2)='XB'
				order by convert(datetime,dt_ins_hia,105) desc
				)
		
		END
		return @valor
END


GO
