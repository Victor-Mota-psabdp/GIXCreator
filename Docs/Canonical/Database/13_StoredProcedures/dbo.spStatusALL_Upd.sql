SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spStatusALL_Upd]

as

Begin Transaction


--Status 1 - Pre-Embarque: Quando o processo não contiver ETD informado

BEGIN
	UPDATE llp_exp_mar SET id_status = 1 
		WHERE num_proc_lem in (select num_proc_lem from llp_exp_mar where (id_status not in(1,4,5,6,7,8,9) or id_status is null) and  atd_lem is null)
	UPDATE llp_exp_out SET id_status = 1 
		WHERE num_proc_leo in (select num_proc_leo from llp_exp_out where (id_status not in(1,4,5,6,7,8,9) or id_status is null) and  atd_leo is null)
	UPDATE llp_exp_aer SET id_status = 1 
		WHERE num_proc_lea in (select num_proc_lea from llp_exp_aer where (id_status not in(1,4,5,6,7,8,9) or id_status is null) and  atd_lea is null)
	UPDATE llp_imp_aer SET id_status = 1 
		WHERE num_proc_lia in (select num_proc_lia from llp_imp_aer where (id_status not in(1,4,5,6,7,8,9) or id_status is null) and  atd_lia is null)
	UPDATE llp_imp_mar SET id_status = 1 
		WHERE num_proc_lim in (select num_proc_lim from llp_imp_mar where (id_status not in(1,4,5,6,7,8,9) or id_status is null) and  atd_lim is null)
	UPDATE llp_imp_out SET id_status = 1 
		WHERE num_proc_lio in (select num_proc_lio from llp_imp_out where (id_status not in(1,4,5,6,7,8,9) or id_status is null) and  atd_lio is null)
END

--Status 2 - EM Transito: Quando o processo não contiver ATA informado

BEGIN
	UPDATE llp_exp_mar SET id_status = 2 
		WHERE num_proc_lem in (select num_proc_lem from llp_exp_mar where (id_status not in(2,5,6,7,8,9) or id_status is null) and ata_lem is null and atd_lem is NOT null)
	UPDATE llp_exp_out SET id_status = 2 
		WHERE num_proc_leo in (select num_proc_leo from llp_exp_out where (id_status not in(2,5,6,7,8,9) or id_status is null) and ata_leo is null and atd_leo is NOT null)
	UPDATE llp_exp_aer SET id_status = 2 
		WHERE num_proc_lea in (select num_proc_lea from llp_exp_aer where (id_status not in(2,5,6,7,8,9) or id_status is null) and ata_lea is null and atd_lea is NOT null)
	UPDATE llp_imp_aer SET id_status = 2 
		WHERE num_proc_lia in (select num_proc_lia from llp_imp_aer where (id_status not in(2,5,6,7,8,9) or id_status is null) and ata_lia is null and atd_lia is NOT null)
	UPDATE llp_imp_mar SET id_status = 2
		WHERE num_proc_lim in (select num_proc_lim from llp_imp_mar where (id_status not in(2,5,6,7,8,9) or id_status is null) and ata_lim is null and atd_lim is NOT null)
	UPDATE llp_imp_out SET id_status = 2 
		WHERE num_proc_lio in (select num_proc_lio from llp_imp_out where (id_status not in(2,5,6,7,8,9) or id_status is null) and ata_lio is null and atd_lio is NOT null)
END


--Status 4 - Faturamento: Quando o processo contiver ATA informado, documento anexado >= 1(20-documento de Embarque ou 44-BL) e Taxas no BDP Charges em Aberto
BEGIN
	UPDATE llp_exp_mar SET id_status = 4
		WHERE num_proc_lem in (
			select distinct LEM.num_proc_lem 
				from llp_exp_mar LEM
				join doc_anexos DA on LEM.num_proc_lem = DA.num_proc
				join cta_cte_hou_exp_mar CC on CC.num_proc_hem = LEM.num_proc_lem
				left join Caixa_Hou_exp_Mar CXA on CC.num_proc_hem = CXA.num_proc_hem and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hem = CXA.dc_hem	
			where 
				(lem.id_status not in(4,5,6,7,8,9) or lem.id_status is null) and lem.ata_lem is NOT null and (da.id_dc = 20 or da.id_dc = 44)and cxa.num_lcto is null)

	UPDATE llp_exp_out SET id_status = 4 
		WHERE num_proc_leo in (
			select distinct LEO.num_proc_leo	
				from llp_exp_out LEO
				join doc_anexos DA on LEO.num_proc_leo = DA.num_proc
				join cta_cte_hou_exp_out CC on CC.num_proc_heo = LEO.num_Proc_leo
				left join Caixa_Hou_Exp_out CXA on CC.num_proc_heo = CXA.num_proc_heo and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_heo = CXA.dc_heo 
			where 
				(leo.id_status not in(4,5,6,7,8,9) or leo.id_status is null) and leo.ata_leo is NOT null and (da.id_dc = 20 or da.id_dc = 44)and cxa.num_lcto is null)

	UPDATE llp_exp_aer SET id_status = 4 
		WHERE num_proc_lea in (
			select distinct LEA.num_proc_lea	
				from llp_exp_aer LEA
				join doc_anexos DA on LEA.num_proc_lea = DA.num_proc
				join cta_cte_hou_exp_aer CC on CC.num_proc_hea= LEA.num_Proc_lea
				left join Caixa_Hou_exp_aer  CXA on CC.num_proc_hea = CXA.num_proc_hea and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hea = CXA.dc_hea	
			where 
				(lea.id_status not in(4,5,6,7,8,9) or lea.id_status is null) and lea.ata_lea is NOT null and (da.id_dc = 20 or da.id_dc = 44) and cxa.num_lcto is null)

	UPDATE llp_imp_aer SET id_status = 4 
		WHERE num_proc_lia in (
			select distinct LIA.num_proc_lia	
				from llp_imp_aer LIA
				join doc_anexos DA on LIA.num_proc_lia = DA.num_proc
				join cta_cte_hou_imp_aer CC on CC.num_proc_hia = LIA.num_Proc_lia
				left join Caixa_Hou_Imp_aer CXA on CC.num_proc_hia = CXA.num_proc_hia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hia = CXA.dc_hia		
			where 
				(lia.id_status not in(4,5,6,7,8,9) or lia.id_status is null) and lia.ata_lia is NOT null and (da.id_dc = 20 or da.id_dc = 44)and cxa.num_lcto is null)

	UPDATE llp_imp_mar SET id_status = 4
		WHERE num_proc_lim in (
			select distinct LIM.num_proc_lim	
				from llp_imp_mar LIM
				join doc_anexos DA on Lim.num_proc_lim = DA.num_proc
				join cta_cte_hou_imp_mar CC on CC.num_proc_him = LIM.num_Proc_lim
				left join Caixa_Hou_Imp_Mar CXA on CC.num_proc_him = CXA.num_proc_him and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_him = CXA.dc_him		
			where 
				(lim.id_status not in(4,5,6,7,8,9) or lim.id_status is null) and lim.ata_lim is NOT null and (da.id_dc = 20 or da.id_dc = 44)and cxa.num_lcto is null)

	UPDATE llp_imp_out SET id_status = 4 
		WHERE num_proc_lio in (
			select distinct LIO.num_proc_lio
				from llp_imp_out LIO
				join doc_anexos DA on LIO.num_proc_lio = DA.num_proc
				join cta_cte_hou_imp_out CC on CC.num_proc_hio = LIO.num_Proc_lio
				left join Caixa_Hou_Imp_out CXA on CC.num_proc_hio = CXA.num_proc_hio and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hio = CXA.dc_hio	
			where 
				(lio.id_status not in(4,5,6,7,8,9) or lio.id_status is null) and lio.ata_lio is NOT null and (da.id_dc = 20 or da.id_dc = 44)	and cxa.num_lcto is null)
END

--Status 7 – Close Only for BDP Charges: Quando o net-revenue é positivo e existe uma Fatura Emitida (Tabela Fatura)
BEGIN
	UPDATE llp_exp_mar SET id_status = 7 
		Where dbo.FNetRevenue_Sel(Num_Proc_Lem)>0 and
			num_proc_lem in (select left(fatcod,16) from fatura where fatstatus=0)
			and ata_lem is not null and isnull(id_status,4)<=4 
	UPDATE llp_exp_out SET id_status = 7 
		Where dbo.FNetRevenue_Sel(Num_Proc_Leo)>0 and
			num_proc_leo in (select left(fatcod,16) from fatura where fatstatus=0)
			and ata_leo is not null and isnull(id_status,4)<=4 
	UPDATE llp_exp_aer SET id_status = 7 
		Where dbo.FNetRevenue_Sel(Num_Proc_Lea)>0 and
			num_proc_lea in (select left(fatcod,16) from fatura where fatstatus=0)
			and ata_lea is not null and isnull(id_status,4)<=4 
	UPDATE llp_imp_aer SET id_status = 7 
		Where dbo.FNetRevenue_Sel(Num_Proc_Lia)>0 and
			num_proc_lia in (select left(fatcod,16) from fatura where fatstatus=0)
			and ata_lia is not null and isnull(id_status,4)<=4 
	UPDATE llp_imp_mar SET id_status = 7
		Where dbo.FNetRevenue_Sel(Num_Proc_Lim)>0 and
			num_proc_lim in (select left(fatcod,16) from fatura where fatstatus=0)
			and ata_lim is not null and isnull(id_status,4)<=4 
	UPDATE llp_imp_out SET id_status = 7 
		Where dbo.FNetRevenue_Sel(Num_Proc_Lio)>0 and
			num_proc_lio in (select left(fatcod,16) from fatura where fatstatus=0)
			and ata_lio is not null and isnull(id_status,4)<=4 

END

Commit Transaction































--Status 5 - Processo Encerrado: Quando o processo contiver ATA informado e NÃO existir Taxas no BDP Charges em Aberto
--BEGIN
--	UPDATE llp_exp_mar SET id_status = 5
--		WHERE num_proc_lem in (
--			select distinct LEM.num_proc_lem
--				from llp_exp_mar LEM
--				join doc_anexos DA on LEM.num_proc_lem = DA.num_proc
--				join cta_cte_hou_exp_mar CC on CC.num_proc_hem = LEM.num_proc_lem
--				left join Caixa_Hou_exp_Mar CXA on CC.num_proc_hem = CXA.num_proc_hem and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hem = CXA.dc_hem	
--			where 
--				(lem.id_status not in(5,6,7,8,9)or lem.id_status is null) and lem.ata_lem is NOT null and cxa.num_lcto is NOT null)
--
--
--	UPDATE llp_exp_out SET id_status = 5
--		WHERE num_proc_leo in (
--			select distinct LEO.num_proc_leo	
--				from llp_exp_out LEO
--				join doc_anexos DA on LEO.num_proc_leo = DA.num_proc
--				join cta_cte_hou_exp_out CC on CC.num_proc_heo = LEO.num_Proc_leo
--				left join Caixa_Hou_Exp_out CXA on CC.num_proc_heo = CXA.num_proc_heo and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_heo = CXA.dc_heo
--			where 
--				(leo.id_status not in(5,6,7,8,9)or leo.id_status is null) and leo.ata_leo is NOT null and cxa.num_lcto is NOT null)
--
--	UPDATE llp_exp_aer SET id_status = 5
--		WHERE num_proc_lea in (
--			select distinct LEA.num_proc_lea	
--				from llp_exp_aer LEA
--				join doc_anexos DA on LEA.num_proc_lea = DA.num_proc
--				join cta_cte_hou_exp_aer CC on CC.num_proc_hea= LEA.num_Proc_lea
--				left join Caixa_Hou_exp_aer  CXA on CC.num_proc_hea = CXA.num_proc_hea and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hea = CXA.dc_hea	
--			where 
--				(lea.id_status not in(5,6,7,8,9)or lea.id_status is null) and lea.ata_lea is NOT null and cxa.num_lcto is NOT null)
--
--	UPDATE llp_imp_aer SET id_status = 5 
--		WHERE num_proc_lia in (
--			select distinct LIA.num_proc_lia	
--				from llp_imp_aer LIA
--				join doc_anexos DA on LIA.num_proc_lia = DA.num_proc
--				join cta_cte_hou_imp_aer CC on CC.num_proc_hia = LIA.num_Proc_lia
--				left join Caixa_Hou_Imp_aer CXA on CC.num_proc_hia = CXA.num_proc_hia and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hia = CXA.dc_hia		
--			where 
--				(lia.id_status not in(5,6,7,8,9)or lia.id_status is null) and lia.ata_lia is NOT null and cxa.num_lcto is NOT null)
--
--	UPDATE llp_imp_mar SET id_status = 5
--		WHERE num_proc_lim in (
--			select distinct LIM.num_proc_lim	
--				from llp_imp_mar LIM
--				join doc_anexos DA on Lim.num_proc_lim = DA.num_proc
--				join cta_cte_hou_imp_mar CC on CC.num_proc_him = LIM.num_Proc_lim
--				left join Caixa_Hou_Imp_Mar CXA on CC.num_proc_him = CXA.num_proc_him and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_him = CXA.dc_him		
--			where 
--				(lim.id_status not in(5,6,7,8,9)or lim.id_status is null) and lim.ata_lim is NOT null and cxa.num_lcto is NOT null)
--
--	UPDATE llp_imp_out SET id_status = 5 
--		WHERE num_proc_lio in (
--			select distinct LIO.num_proc_lio
--				from llp_imp_out LIO
--				join doc_anexos DA on LIO.num_proc_lio = DA.num_proc
--				join cta_cte_hou_imp_out CC on CC.num_proc_hio = LIO.num_Proc_lio
--				left join Caixa_Hou_Imp_out CXA on CC.num_proc_hio = CXA.num_proc_hio and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_hio = CXA.dc_hio		
--			where 
--				(lio.id_status not in(5,6,7,8,9)or lio.id_status is null) and lio.ata_lio is NOT null and cxa.num_lcto is NOT null)
--END





GO
