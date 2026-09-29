SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select max(fatstatus) St from fatura
--update fatura set fatstatus= where fatcod='imifb201107045brb '
--select * from fatura where fatstatus = 4fatcod='imifb201107045brb '

/*
select * from item_fat where fatcod like 'IMGIG20100501201D%'
select * from Fatura where fatcod like 'IMGIG20100501201D%'
select * from Master_imp_mar where num_proc_mim like 'IMGIG201005012%'
--select * from house_imp_mar where num_proc_him like 'IMIFB%'

spFatura_inf 'IM','01/18/2010',4
spFatura_inf 'IM','01/01/2010',4

Incluido o 'P000016190' pq agora estão usando este cd_pes
*/

CREATE Procedure [dbo].[spFatura_inf] 
	@Modal Char(2),
	@data  varchar(10),
	@Status int
AS

	Select distinct
		Nome_raz_soc, fat.fatcod,isnull(MAS.mawb_mim,HOU.MAWB_HIM) MAWB, isnull(MAS.dt_atrac_mim,convert(varchar(10),LLP.ETA_LIM,103)) Data, nome_tp_Tx, 
		itf.cd_tp_moeda, Vlr_org, 0 Paridade,fatobs,Par_moeda  
	from 
		item_fat ITF
		Join Fatura FAT on FAt.fatcod=ITF.fatcod
		Join pessoa pp on pp.cd_pes=FAT.cd_pes
		left Join Master_imp_mar mas on mas.num_proc_mim=left(itf.num_proc,14)
		Join House_Imp_Mar HOU on HOU.Num_Proc_HIM = left(itf.num_proc,16)
		left Join LLP_Imp_Mar LLP on LLP.Num_Proc_LIM = left(itf.num_proc,16)
		lEFT Join Paridade PAR on PAR.cd_tp_par='IMM' and convert(Datetime,dt_par,105)=@data and par.cd_tp_moeda=itf.cd_tp_moeda		
--		Left Join Localidade Org on org.cd_local = isnull(MAS.cd_org_mim,HOU.cd_org_him)
--		Left join localidade dst on dst.cd_local = isnull(MAS.cd_dst_mim,HOU.cd_dst_him)
		Join Tipo_taxa tt on tt.cd_tp_tx = itf.cd_tp_Tx
	Where 
		--fat.cd_pes='21930080' 		
		-- Alessandra 30/03/2020 - novo cadastro da infineum
		--fat.cd_pes in ('21930080','P000016190')
		fat.cd_pes in ('21930080','P000016190','P000037929')

		and FAT.fatstatus=@Status --and HOU.Num_Proc_HIM = 'IMIFB20100601501'
		and fatdtvenc >=getdate()-365
--	Group by
--		Nome_raz_soc, fat.fatcod,isnull(MAS.mawb_mim,HOU.MAWB_HIM) , isnull(MAS.dt_atrac_mim,convert(varchar(10),LLP.ETA_LIM,103)) , nome_tp_Tx, 
--		itf.cd_tp_moeda, Vlr_org, fatobs,Par_moeda  

UNION

	Select distinct
		Nome_raz_soc, fat.fatcod,hou.mawb_hem MAWB, convert(varchar(10),atd_lem,103) Data, nome_tp_Tx, 
		itf.cd_tp_moeda, Vlr_org, 0 Paridade, fatobs,Par_moeda  
	from 
		item_fat ITF
		Join Fatura FAT on FAt.fatcod=ITF.fatcod
		Join pessoa pp on pp.cd_pes=FAT.cd_pes
		Left Join Paridade PAR on PAR.cd_tp_par='EXM' and convert(Datetime,dt_par,105)=@data and par.cd_tp_moeda=itf.cd_tp_moeda
		Join house_exp_mar hou on hou.num_proc_hem=left(fat.fatcod,16)
		Left Join LLP_Exp_mar llp on llp.num_proc_lem=hou.num_proc_hem
		left Join Master_exp_mar mas on mas.num_proc_mem=hou.num_proc_mem
--		LEFT Join Localidade Org on org.cd_local=cd_org_hem
--		LEFT join localidade dst on dst.cd_local=cd_dst_hem
		LEFT Join Tipo_taxa tt on tt.cd_tp_tx=itf.cd_tp_Tx
	Where 
		--fat.cd_pes='21930080' 
		-- Alessandra 30/03/2020 - novo cadastro da infineum
		--fat.cd_pes in ('21930080','P000016190')
		fat.cd_pes in ('21930080','P000016190','P000037929')
		and FAT.fatstatus=@Status --and hou.num_proc_hem = 'EMATL20100401501'
		and fatdtvenc >=getdate()-365
--	Group by
--		Nome_raz_soc, fat.fatcod,hou.mawb_hem, convert(varchar(10),atd_lem,103), nome_tp_Tx, 
--		itf.cd_tp_moeda, Vlr_org, fatobs,Par_moeda  

UNION

	Select distinct
		Nome_raz_soc, fat.fatcod,isnull(mawb_mia,HOU.mawb_hia) MAWB, isnull(dt_cheg_mia,convert(varchar(10),LLP.ETA_LIA,103)) Data, nome_tp_Tx, 
		itf.cd_tp_moeda, Vlr_org, 0 Paridade, fatobs,Par_moeda  
	from 
		item_fat ITF
		Join Fatura FAT on FAt.fatcod=ITF.fatcod
		Join pessoa pp on pp.cd_pes=FAT.cd_pes
		left Join Master_imp_aer mas on mas.num_proc_mia=left(itf.num_proc,14)
		Join House_Imp_Aer HOU on HOU.Num_Proc_HIA = left(itf.num_proc,16)
		Left Join LLP_Imp_Aer LLP on LLP.Num_Proc_LIA = left(itf.num_proc,16)
		lEFT Join Paridade PAR on PAR.cd_tp_par='IFN' and convert(Datetime,dt_par,105)=@data and par.cd_tp_moeda=itf.cd_tp_moeda		
--		Join Localidade Org on org.cd_local=cd_org_mia
--		join localidade dst on dst.cd_local=cd_dst_mia
		Join Tipo_taxa tt on tt.cd_tp_tx=itf.cd_tp_Tx
	Where 
		--fat.cd_pes='21930080' 
		-- Alessandra 30/03/2020 - novo cadastro da infineum
		--fat.cd_pes in ('21930080','P000016190')
		fat.cd_pes in ('21930080','P000016190','P000037929')
		and FAT.fatstatus=@Status
		and fatdtvenc >=getdate()-365
--	Group by
--		Nome_raz_soc, fat.fatcod,isnull(mawb_mia,HOU.mawb_hia), isnull(dt_cheg_mia,convert(varchar(10),LLP.ETA_LIA,103)), nome_tp_Tx, 
--		itf.cd_tp_moeda, Vlr_org, fatobs,Par_moeda  

UNION

	SELECT distinct
		Nome_raz_soc,fat.fatcod,isnull(MAWB_MEA,HOU.mawb_hea) MAWB, isnull(dt_emis_mea,LLP.ATD_LEA) Data,Nome_tp_tx,itf.cd_tp_moeda,
		Vlr_Org, 0 Paridade,fatobs,Par_moeda
	From
		Item_fat ITF
		Join Fatura FAT on FAt.fatcod=ITF.fatcod
		Join pessoa pp on pp.cd_pes=FAT.cd_pes
		lEFT join master_exp_aer mas on mas.mawb_mea=itf.fatcod
		Join House_exp_aer HOU on HOU.Num_Proc_HEA = left(itf.num_proc,16)
		left Join LLP_exp_aer LLP on LLP.Num_Proc_LEA = left(itf.num_proc,16)
		Left Join Paridade PAR on PAR.cd_tp_par='IFN' and convert(datetime,dt_par,105)=@data and par.cd_tp_moeda=itf.cd_tp_moeda
		Join Tipo_Taxa TT on TT.cd_tp_tx=ITF.cd_tp_tx
	Where
		--fat.cd_pes='21930080' 
		-- Alessandra 30/03/2020 - novo cadastro da infineum
		--fat.cd_pes in ('21930080','P000016190')
		fat.cd_pes in ('21930080','P000016190','P000037929')
		and FAT.fatstatus=@Status 
		and left(Mas.num_proc_mea,2) in ('RD','EA') and fatdtvenc >=getdate()-365
--	Group by
--		Nome_raz_soc,fat.fatcod,isnull(MAWB_MEA,HOU.mawb_hea), isnull(dt_emis_mea,LLP.ATD_LEA) ,Nome_tp_tx,itf.cd_tp_moeda,
--		Vlr_Org, fatobs,Par_moeda









GO
