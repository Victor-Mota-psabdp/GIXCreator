SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spImpCta_Ins]
(
	@StrTX as Char(3),
	@Vlr	as Float,
	@Processo	Char(16)
)
as
BEGIN


If @Vlr=0 
	BEGIN 
		RETURN 0 
	END
ELSE
	BEGIN

		if left(@processo,2)='EM' 	

			BEGIN

			Insert CtA_cte_hou_exp_mar
			
				Select 
					HOU.Num_Proc_HEM,@StrTX,'D','ATL',convert(varchar,getdate(),105),'REL',@Vlr,
					convert(varchar,getdate()+20,105),Cd_Export_Hem,'N','N','S','N','N','N',NULL,
					NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
				From llp_exp_mar LLP
				Join House_Exp_Mar HOU on llp.num_proc_lem=hou.num_proc_hem
				Join Pessoa PP on PP.cd_pes=Cd_Export_HEM
				Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_export_hem
		--		Join Tarefas_Processos TP on TP.num_proc=num_proc_lem and Id_Task=4
				Left Join Cta_cte_hou_exp_mar CTA on num_proc_lem=CTA.num_proc_hem and Cd_tp_Tx=@StrTX and dc_hem='D'
				where
					HOU.NUM_PROC_HEM=@Processo
					and cta.num_proc_hem is null

			END


		if left(@processo,2)='EA' 	

			BEGIN

			Insert cta_cte_hou_exp_aer
			
			Select 
				HOU.Num_Proc_HEA,@StrTX,'D','ATL',convert(varchar,getdate(),105),'REL',@Vlr,
				convert(varchar,getdate()+20,105),Cd_Export_HeA,'N','N','S','N','N','N',NULL,
				NULL,NULL,NULL,NULL,NULL,'N','N',0,NULL,0,NULL,NULL,NULL
			From llp_exp_AER LLP
			Join House_Exp_AER HOU on llp.num_proc_leA=hou.num_proc_heA
			Join Pessoa PP on PP.cd_pes=Cd_Export_HEA
			Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_export_heA
			Join Tarefas_Processos TP on TP.num_proc=num_proc_leA and Id_Task=4
			Left Join Cta_cte_hou_exp_AER CTA on num_proc_lea=CTA.num_proc_hea and Cd_tp_Tx=@StrTX and dc_hea='D'
			where
				HOU.NUM_PROC_HEA=@Processo
				and cta.num_proc_hea is null

			END

		if left(@processo,2)='EO' 	


			BEGIN
			Insert cta_cte_hou_exp_out

				Select 
					HOU.Num_Proc_HEo,@StrTX,'D','ATL',convert(varchar,getdate(),105),'REL',@Vlr,
					convert(varchar,getdate()+20,105),Cd_Export_HEO,'N','N','S','N','N','N',NULL,
					NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
				From llp_exp_OUT LLP
				Join House_Exp_OUT HOU on llp.num_proc_leO=hou.num_proc_heO
				Join Pessoa PP on PP.cd_pes=Cd_Export_HEO
				Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_export_heO
				Join Tarefas_Processos TP on TP.num_proc=num_proc_leO and Id_Task=4
				Left Join Cta_cte_hou_exp_OUT CTA on num_proc_leO=CTA.num_proc_heO and Cd_tp_Tx=@StrTX and dc_heO='D'
				where
					HOU.NUM_PROC_HEO=@Processo
					and cta.num_proc_heo is null
			END

		if left(@processo,2)='IO' 	

			BEGIN

			Insert into CtA_ctE_hou_imp_out

				Select 
					HOU.Num_Proc_HIO,@StrTX,'D','ATL',convert(varchar,getdate(),105),'REL',@Vlr,
					convert(varchar,getdate()+20,105),Cd_Consig_HIO,'N','N','S','N','N','N',NULL,
					NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
				From llp_Imp_OUT LLP
				Join House_Imp_OUT HOU on llp.num_proc_lIO=hou.num_proc_hiO
				Join Pessoa PP on PP.cd_pes=Cd_Consig_HIO
				Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_Consig_hiO
				Join Tarefas_Processos TP on TP.num_proc=num_proc_lio and Id_Task=4
				Left Join Cta_cte_hou_imp_OUT CTA on num_proc_lio=CTA.num_proc_hio and Cd_tp_Tx=@StrTX and dc_hio='D'
				where
					HOU.NUM_PROC_HiO=@Processo
					and cta.num_proc_hio is null
			END

		if left(@processo,2)='IM' 	


			BEGIN
				Insert cta_cte_hou_imp_mar

				Select 
					HOU.Num_Proc_HIm,@StrTX,'D','ATL',convert(varchar,getdate(),105),'REL',@Vlr,
					convert(varchar,getdate()+20,105),Cd_Consig_HIM,'N','N','S','N','N','N',NULL,
					NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
				From llp_Imp_Mar LLP
				Join House_Imp_Mar HOU on llp.num_proc_lIm=hou.num_proc_him
				Join Pessoa PP on PP.cd_pes=Cd_Consig_HIm
				Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_Consig_him
				Join Tarefas_Processos TP on TP.num_proc=num_proc_lim and Id_Task=4
				Left Join Cta_cte_hou_imp_mar CTA on num_proc_lim=CTA.num_proc_him and Cd_tp_Tx=@StrTX and dc_him='D'
				where
					HOU.NUM_PROC_Him=@Processo
					and cta.num_proc_him is null
			END

		if left(@processo,2)='IA' 	

			BEGIN

				Insert ctA_cte_hou_imp_aer

				Select 
					HOU.Num_Proc_HIA,@StrTX,'D','ATL',convert(varchar,getdate(),105),'REL',@Vlr,
					convert(varchar,getdate()+20,105),Cd_Consig_HIA,'N','N','S','N','N','N',NULL,
					NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
				From llp_Imp_Aer LLP
				Join House_Imp_Aer HOU on llp.num_proc_lIa=hou.num_proc_hia
				Join Pessoa PP on PP.cd_pes=Cd_Consig_HIa
				Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_Consig_hia
				Join Tarefas_Processos TP on TP.num_proc=num_proc_lia and Id_Task=4
				Left Join Cta_cte_hou_imp_aer CTA on num_proc_lia=CTA.num_proc_hia and Cd_tp_Tx=@StrTX and dc_hia='D'
				where
					HOU.NUM_PROC_Hia=@Processo
					and cta.num_proc_hia is null
			END
			
		if left(@processo,2)='BO' 	

			BEGIN

			Insert into Cta_Cte_HOU_BDP_OUT

				Select 
					HOU.Num_Proc_HBO,@StrTX,'D','ATL',convert(varchar,getdate(),105),'REL',@Vlr,
					convert(varchar,getdate()+20,105),HOU.cd_cliente_hbo,'N','N','S','N','N','N',NULL,
					NULL,NULL,NULL,NULL,NULL,'N',0,NULL,0,NULL,NULL,NULL
				From LLP_BDP_OUT LLP
				Join House_BDP_OUT HOU on llp.Num_Proc_LBO=hou.Num_Proc_HBO
				Join Pessoa PP on PP.cd_pes=cd_cliente_hbo
				Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_cliente_hbo
				--Join Tarefas_Processos TP on TP.num_proc=Num_Proc_LBO and Id_Task=4
				Left Join Cta_Cte_HOU_BDP_OUT CTA on Num_Proc_LBO=CTA.Num_Proc_HBO and Cd_tp_Tx=@StrTX and DC_HBO='D'
				where
					HOU.Num_Proc_HBO=@Processo
					and cta.Num_Proc_HBO is null
			END		
			

	END
END




GO
