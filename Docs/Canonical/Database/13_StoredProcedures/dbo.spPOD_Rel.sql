SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE       Procedure spPOD_Rel 
	@Modal varchar(2),
	@Regiao varchar(20)	
as 

if @modal='IA' 
 Begin

  select 
	hawb_hia,sh.Nome_Raz_Soc Shipper, pp.Nome_Raz_Soc Consignee, max(convert(datetime,dt_pgto_rcto_hia,105)) Pgto,
	Org.Nome_Local Origin, Dst.Nome_Local Destination, cb.Nome_Raz_Soc Broker,Obs_HIA Notes
	
  from 
	house_imp_aer hou
	Join Master_imp_aer mas on mas.num_proc_mia=hou.num_proc_mia
	Join Pessoa pp on pp.cd_pes=cd_consig_hia
	Join pessoa Sh on sh.cd_pes=cd_exporT_hia
	Join caixa_hou_imp_aer CXA on CXA.num_proc_hia=hou.num_proc_hia and cd_tp_Tx in ('FRT','DES') and dc_hia='C'
	Join Localidade org on org.cd_local=cd_org_hia
	Join regiao RG on RG.cd_regiao=org.cd_regiao
	Join Localidade dst on dst.cd_local=cd_dst_hia
	Left Join Relacao RL on pp.cd_pes=RL.cd_pes_A and cd_tp_rel='DSP'
	Left Join pessoa CB on cd_pes_b=cb.cd_pes
  Where
	convert(datetime,dt_pgto_Rcto_hia,105)>=getdate()-7  and convert(datetime,dt_pgto_rcto_hia,105)<=getdate() and nome_regiao like @regiao

	Group by 
	hawb_hia,sh.Nome_Raz_Soc, pp.Nome_Raz_Soc, Org.Nome_Local, Dst.Nome_Local, cb.Nome_Raz_Soc,Obs_HIA

  END

else

  select 
	hawb_him,sh.Nome_Raz_Soc Shipper, pp.Nome_Raz_Soc Consignee, max(convert(datetime,dt_pgto_rcto_him,105)) Pgto,
	Org.Nome_Local Origin, Dst.Nome_Local Destination, cb.Nome_Raz_Soc Broker,''    
  from 
	house_imp_mar hou
	Join Master_imp_mar mas on mas.num_proc_mim=hou.num_proc_mim
	Join Pessoa pp on pp.cd_pes=cd_consig_him
	Join pessoa Sh on sh.cd_pes=cd_exporT_him
	Join caixa_hou_imp_mar CXA on CXA.num_proc_him=hou.num_proc_him and cd_tp_Tx in ('FRT','DES') and dc_him='C'
  	Join Localidade org on org.cd_local=cd_org_him
	Join regiao RG on rg.cd_regiao=org.cd_regiao 
	Join Localidade dst on dst.cd_local=cd_dst_him
	Left Join Relacao RL on pp.cd_pes=cd_pes_a and (cd_tp_rel='DSS' or Obs_Rel='SEA')
	Left Join pessoa CB on cd_pes_b=cb.cd_pes	

  Where
	convert(datetime,dt_pgto_Rcto_him,105)>=getdate()-7 and Nome_Regiao like @regiao and convert(datetime,dt_pgto_rcto_him,105)<=getdate()

  Group by 
	hawb_him,sh.Nome_Raz_Soc, pp.Nome_Raz_Soc, Org.Nome_Local , Dst.Nome_Local, cb.Nome_Raz_Soc   








GO
