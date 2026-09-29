SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--10-01-2018 - retirado o BO - cadu
--10/04/18 - cadu - incluido o esquema do bo
--29-04-2021 - cadu - incluido o cd_agente
--09/11/2022 - Cadu - inclusao do isnull(vlr_frete_tot_hem,0)
--05102024 - [dbo].[RemoveNonAlphaCharacters]( OBS
CREATE Procedure [dbo].[spProcesso_Sel] 
		(
		@Num_Proc	Char(16)
		)
	
as
IF LEFT(@NUM_PROC,2)='EM'
	BEGIN
		SELECT 
			Cd_Courier, courier_number_lem courier_number, HOU.MAWB_HEM MAWB,Cd_Planta_Lem Cd_Origem, Cd_DstFinal_Lem Cd_Destino, Eta_LEM ETA, ETD_LEM ETD, ATA_LEM ATA, ATD_LEM ATD, hou.cd_org_hem cd_org, hou.cd_dst_hem cd_dst,Upper(hou.NUM_PROC_HEM) Processo, Job_Hem Job,
			hou.cd_consig_hem cd_Consig,hou.cd_notify_hem cd_notify, hou.cd_export_hem cd_export, replace(replace(replace(ltrim(rtrim(nr_reserva)),char(10),''),char(13),''),char(160),'') NR_Reserva,inv_hem Invoice,
			hou.hawb_hem HAWB, tp_frete_hem tp_frete,Navio_Hem Navio,hou.num_proc_mem Num_Master,Viagem_Hem Viagem, isnull(vlr_frete_tot_hem,0) vlr_frete, dt_emis_hem dt_Emis,
			peso_bruto_hem Peso_Bruto,peso_liquido_hem Peso_Liquido, qtd_tot_vol_hem qtd_tot_vol, vol_tot_hem vol_tot, isnull(cd_tp_oper,'') cd_tp_oper ,cd_tp_prod, DL_Cargo_Lem DL_Carga,DL_Draft_Lem DL_Draft, LLP.Cd_tp_carga,
			
			[dbo].[RemoveNonAlphaCharacters](replace(replace(replace(ltrim(rtrim(obs_hem)),char(10),' '),char(13),' '),char(160),' ')) Obs,
			
			cd_dsp_hem cd_despachante,cd_planta_lem cd_plantaOrigem,cd_dstFinal_lem dstFinal,dt_bl_lem Dt_BL, 
			
			(case when LLP.cd_tp_carga = 1  then '05'
				else				
				(case when LLP.cd_tp_carga =2  then '06'
					else
						'18'
			 end)end) cd_tp_carga_301,
			 
			Nome_Tp_Carga Tipo_Carga,
			
			Null Cd_Forwarder,			
			cast(LLP.ID_Status as varchar(2)) + '-' + Status_Descricao_Ingles Job_Status, DL_VGM_LEM DL_VGM,LLP.Cd_Transportadora
			,JOB.cd_agente
		FROM 
			house_exp_mar hou With(Nolock)
			left join job_exp_mar job with(nolock) on  hou.num_proC_hem=job.num_proc_hem 
			Left Join LLP_Exp_MAr LLP with(nolock)  on hou.num_proc_hem=llp.num_proc_lem
			Left Join Tipo_Carga TC with(nolock)  on TC.Cd_Tp_Carga=LLP.Cd_Tp_Carga
			Left Join Tipo_Status_Processo TSP with(nolock)  on LLP.id_status=TSP.id_status
		WHERE 
			hou.num_proc_hem=@NUM_PROC
	END
IF LEFT(@NUM_PROC,2)='EA'
	BEGIN
		SELECT
			Cd_Courier, courier_number_lea courier_number, HOU.MAWB_HEA MAWB,Cd_Planta_Lea Cd_Origem, Cd_DstFinal_Lea Cd_Destino, Eta_LEA ETA, ETD_LEA ETD, ATA_LEA ATA, ATD_LEA ATD,hou.cd_org_hea cd_org, hou.cd_dst_hea cd_dst,Upper(hou.NUM_PROC_HEA) Processo, Job_Hea Job,
			hou.cd_consig_hea cd_Consig, hou.cd_notify_hea cd_notify,hou.cd_export_hea cd_export, inv_hea Invoice, hou.hawb_hea HAWB,
			tp_frete_hea tp_frete, hou.num_proc_meA Num_Master,Voo_Hea Viagem, dt_emis_hea dt_Emis, peso_bruto_hea Peso_Bruto,peso_real_hea Peso_Liquido,
			qtd_tot_vol_hea qtd_tot_vol, vol_tot_hea vol_tot, isnull(cd_tp_oper,'') cd_tp_oper,isnull(vlr_frete_tot_hea,0)  Vlr_Frete, cd_tp_prod,hou.MAWB_HEA nr_Reserva, (etd_leA-1) dl_Carga,
			
			[dbo].[RemoveNonAlphaCharacters](replace(replace(replace(ltrim(rtrim(obs_hea)),char(10),' '),char(13),' '),char(160),' ')) Obs,
			
			cd_dsp_hea cd_despachante,cd_planta_lea cd_plantaOrigem,cd_dstFinal_lea dstFinal,atd_Lea DT_BL, 'LCL' Tipo_Carga, Null Cd_Forwarder,
			cast(LLP.ID_Status as varchar(2)) + '-' + Status_Descricao_Ingles Job_Status,LLP.Cd_Transportadora
			,JOB.cd_agente
		FROM 
			house_exp_aer hou  With(Nolock)
			left join job_exp_aer job With(Nolock) on  job_hea=job.num_proc_hea 
			left join llp_exp_aer llp With(Nolock) on hou.num_proc_hea=llp.num_proc_lea
			Left Join Tipo_Status_Processo TSP with(nolock)  on LLP.id_status=TSP.id_status

		WHERE 
			hou.num_proc_hea=@NUM_PROC
	END

IF LEFT(@NUM_PROC,2)='IA'
	BEGIN
		SELECT
			Null Cd_Courier, null courier_number, HOU.MAWB_HIA MAWB, Cd_Planta_LIA Cd_Origem, Cd_DstFinal_LIA Cd_Destino, Eta_LIA ETA, ETD_LIA ETD, ATA_LIA ATA, ATD_LIA ATD, hou.cd_org_hia cd_org, hou.cd_dst_hia cd_dst,Upper(hou.NUM_PROC_hia) Processo, Job_hia Job,
			hou.cd_consig_hia cd_Consig, hou.cd_import_hia cd_notify, hou.cd_export_hia cd_export, inv_hia Invoice, hou.hawb_hia HAWB,
			tp_frete_hia tp_frete, hou.num_proc_miA Num_Master,Voo_hia Viagem, dt_emis_hia dt_Emis, peso_bruto_hia Peso_Bruto,peso_real_hia Peso_Liquido,
			qtd_tot_vol_hia qtd_tot_vol, vol_tot_hia vol_tot, cd_tp_oper,isnull(vlr_frete_efet_hia,0)  Vlr_Frete, cd_tp_prod, Intl_ref_lia ref_int,isnull(Original_ETa_LIA,ETA_LIA) Original_ETA,

			[dbo].[RemoveNonAlphaCharacters](replace(replace(replace(ltrim(rtrim(obs_hia)),char(10),' '),char(13),' '),char(160),' ')) Obs, 
			
			
			cd_dsp_hia cd_despachante,cd_planta_lia cd_plantaOrigem,cd_dstFinal_lia dstFinal,ATD_LIA DT_BL, 'LCL' Tipo_Carga, Cd_Forwarder,
			cast(LLP.ID_Status as varchar(2)) + '-' + Status_Descricao_Ingles Job_Status,LLP.Cd_Transportadora
			,JOB.cd_agente
		FROM 
			house_imp_aer hou with(nolock)
			left join job_imp_aer job with(nolock) on  job_hia=job.num_proc_hia 
			left join llp_imp_aer llp with(nolock) on hou.num_proc_hia=llp.num_proc_lia
			Left Join Tipo_Status_Processo TSP with(nolock)  on LLP.id_status=TSP.id_status

		WHERE 
			hou.num_proc_hia=@NUM_PROC
	END
IF LEFT(@NUM_PROC,2)='IM'
	BEGin
		SELECT
			 Cd_Courier,courier_number_lim courier_number, HOU.MAWB_HIM MAWB, Cd_Planta_LIM Cd_Origem, Cd_DstFinal_LIM Cd_Destino, Eta_LIM ETA, ETD_LIM ETD, ATA_LIM ATA, ATD_LIM ATD, hou.cd_org_him cd_org, hou.cd_dst_him cd_dst,Upper(hou.NUM_PROC_him) Processo, Job_him Job,
			hou.cd_consig_him cd_Consig, hou.cd_import_him cd_notify,hou.cd_export_him cd_export,  replace(replace(replace(ltrim(rtrim(nr_reserva)),char(10),''),char(13),''),char(160),'') NR_Reserva,inv_him Invoice,
			hou.hawb_him HAWB, tp_frete_him tp_frete,Navio_him Navio,hou.num_proc_mim Num_Master,Viagem_him Viagem, isnull(vlr_frete_efet_him,0) vlr_frete, dt_emis_him dt_Emis,
			peso_bruto_him Peso_Bruto,peso_liquido_him Peso_Liquido, qtd_tot_vol_him qtd_tot_vol, vol_tot_him vol_tot, cd_tp_oper,cd_tp_prod, Intl_ref_lim ref_int,Isnull(Original_ETA_LIM,Eta_Lim) Original_ETA,
			
			[dbo].[RemoveNonAlphaCharacters](replace(replace(replace(ltrim(rtrim(obs_him)),char(10),' '),char(13),' '),char(160),' ')) Obs,
			cd_despachante cd_despachante, cd_planta_lim cd_plantaOrigem,cd_dstFinal_lim dstFinal,ATD_LIM DT_BL, Nome_tp_Carga Tipo_carga,cd_forwarder,
			cast(LLP.ID_Status as varchar(2)) + '-' + Status_Descricao_Ingles Job_Status,LLP.Cd_Transportadora
			,JOB.cd_agente
		FROM 
			house_imp_mar hou with(nolock)
			left join job_imp_mar job With(Nolock) on  job_him=job.num_proc_him 
			Left Join LLP_imp_MAr LLP With(Nolock) on hou.num_proc_him=llp.num_proc_lim
			LEFT Join Tipo_Carga TC With(Nolock) on TC.Cd_Tp_Carga=LLP.Cd_Tp_Carga
			Left Join Tipo_Status_Processo TSP with(nolock)  on LLP.id_status=TSP.id_status
		WHERE 
			hou.num_proc_him=@NUM_PROC
	END

IF LEFT(@NUM_PROC,2)='IO'
	BEGIN
		SELECT
			Null Cd_Courier, Null courier_number, HOU.MAWB_HIO MAWB, Cd_Planta_LIO Cd_Origem, Cd_DstFinal_LIO Cd_Destino, Eta_LIO ETA, ETD_LIO ETD, ATA_LIO ATA, ATD_LIO ATD, hou.cd_org_hio cd_org, hou.cd_dst_hio cd_dst,Upper(hou.NUM_PROC_hio) Processo, Null Job,
			hou.cd_consig_hio cd_Consig, hou.Cd_Import_HIO cd_notify,hou.cd_export_hio cd_export, hou.hawb_hio nr_reserva,Null Invoice,
			hou.hawb_hio MAWB,hou.hawb_hio HAWB, tp_frete_hio tp_frete,Null Navio,hou.hawb_hIo Num_Master,Null Viagem, isnull(vlr_frete_efet_hio,0) vlr_frete, dt_emis_hio dt_Emis,
			peso_bruto_hio Peso_Bruto,Peso_Real_HIO Peso_Liquido, qtd_tot_vol_hio qtd_tot_vol, vol_tot_hio vol_tot, cd_tp_oper,Null cd_tp_prod, Intl_ref_lio ref_int,Tipo_Lio Tipo_Tranp,Dt_Previsao DL_Carga,isnull(Original_ETA_LIO,ETA_LIO) Original_ETA,
			
			[dbo].[RemoveNonAlphaCharacters](replace(replace(replace(ltrim(rtrim(obs_hio)),char(10),' '),char(13),' '),char(160),' ')) OBS,
			
			cd_despachante , cd_planta_lio cd_plantaOrigem,cd_dstFinal_lio dstFinal,ATD_LIO DT_BL, 'LCL' Tipo_Carga,Cd_Forwarder,
			cast(LLP.ID_Status as varchar(2)) + '-' + Status_Descricao_Ingles Job_Status,LLP.Cd_Transportadora
			,LLP.cd_agente
		FROM 
			house_imp_OUT hou with(nolock)
			--left join job_imp_OUT job on  job_hio=job.num_proc_hio 
			Left Join LLP_imp_OUT LLP With(Nolock) on hou.num_proc_hio=llp.num_proc_lio
			Left Join Tarefas_Processos TF With(Nolock) on hou.num_proc_hio=TF.num_proc and TF.ID_Task=10
			Left Join Tipo_Status_Processo TSP with(nolock)  on LLP.id_status=TSP.id_status

		WHERE 
			hou.num_proc_hio=@NUM_PROC
	END

IF LEFT(@NUM_PROC,2)='EO'
	BEGIN
		SELECT
			Cd_Courier, courier_number_leO courier_number, HOU.MAWB_HEO MAWB, Cd_Planta_LEO Cd_Origem, Cd_DstFinal_LeO Cd_Destino, Eta_LEO ETA, ETD_LEO ETD, ATA_LEO ATA, ATD_LEO ATD, hou.cd_org_heo cd_org, hou.cd_dst_heo cd_dst,Upper(hou.NUM_PROC_heo) Processo, NULL Job,
			hou.cd_consig_heo cd_Consig, hou.Cd_Notify_HEO cd_notify, hou.cd_export_heo cd_export, nr_reserva,NULL Invoice,
			hou.hawb_heo HAWB, tp_frete_heo tp_frete,NULL Navio,hou.hawb_heo Num_Master,NULL Viagem, isnull(vlr_frete_efet_heo,0) vlr_frete, dt_emis_heo dt_Emis,
			peso_bruto_heo Peso_Bruto,peso_real_heo Peso_Liquido, qtd_tot_vol_heo qtd_tot_vol, vol_tot_heo vol_tot, isnull(cd_tp_oper,'') cd_tp_oper,null cd_tp_prod, Tipo_Leo Tipo_Tranp, (ETD_Leo) DL_Carga,hou.hawb_heo MAWB,
			
			[dbo].[RemoveNonAlphaCharacters](replace(replace(replace(ltrim(rtrim(obs_heo)),char(10),' '),char(13),' '),char(160),' ')) Obs,
			cd_despachante, cd_planta_leo cd_plantaOrigem,cd_dstFinal_leo dstFinal,ATD_LEO DT_BL, 'LCL' Tipo_Carga,Null Cd_Forwarder,
			cast(LLP.ID_Status as varchar(2)) + '-' + Status_Descricao_Ingles Job_Status,LLP.Cd_Transportadora
			,LLP.cd_agente
		FROM 
			house_exp_out hou   With(Nolock)
--			left join job_exp_out job on  job_heo=job.num_proc_heo 
			Left Join LLP_Exp_out LLP With(Nolock) on hou.num_proc_heo=llp.num_proc_leo
			Left Join Tipo_Status_Processo TSP with(nolock)  on LLP.id_status=TSP.id_status
		WHERE 
			hou.num_proc_heo=@NUM_PROC
	END

--IF LEFT(@NUM_PROC,2)='BO'
--	BEGIN
--		SELECT
--			Null Cd_Courier, Null courier_number, Null MAWB, Null Cd_Origem, Null Cd_Destino, Null ETA, Null ETD,
--			 Null ATA, Null ATD,
--			 NULL cd_org, Null cd_dst,Upper(hou.Num_Proc_HBO) Processo, Null Job,
--			cd_cliente_hbo cd_Consig, NULL cd_export, Null nr_reserva,Null Invoice,
--			Null MAWB,Null HAWB, 'C' tp_frete,Null Navio,'JOB' Num_Master,Null Viagem, '0.00' vlr_frete, Dt_Emis_HBO dt_Emis,
--			Null Peso_Bruto,Null Peso_Liquido, Null qtd_tot_vol, Null vol_tot, Null cd_tp_oper,Null cd_tp_prod, 
--			Null ref_int,'T' Tipo_Tranp,Dt_Previsao DL_Carga,Null Original_ETA,
--			Descr_Serv_HBO OBS,Null cd_despachante, Null cd_plantaOrigem,Null dstFinal,Null DT_BL, 'LCL' Tipo_Carga,
--			Null cd_forwarder,
--			cast(LLP.ID_Status as varchar(2)) + '-' + Status_Descricao_Ingles Job_Status
--		FROM 
--			House_BDP_OUT hou 			
--			Left Join LLP_BDP_OUT LLP With(Nolock) on hou.num_proc_hbo=llp.num_proc_lbo
--			Left Join Tarefas_Processos TF With(Nolock) on hou.Num_Proc_HBO=TF.num_proc and TF.ID_Task=40
--			Left Join Tipo_Status_Processo TSP with(nolock)  on LLP.id_status=TSP.id_status

--		WHERE 
--			hou.num_proc_hbo=@NUM_PROC 
--			and Id_TP_Servico <> 1
--	END
































GO
