SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE      Procedure spUncFreight 

		@IntStatus as int


as	

if @intstatus=1 

	BEGIN

		select 
			HOU.num_proc_hia, hawb_hia, Upper(Nome_Raz_soc) Cliente, 
			Convert(Datetime,dt_cheg_mia,105) Data, upper(cd_org_hia) ORG, 
			Vlr_Frete_Efet_HIA, Tp_Frete_HIA,max(hsdDescricao) Obs  
		from 
			house_imp_aer HOU
			Join Master_imp_aer MAS on MAS.num_proc_mia=HOU.num_proC_mia
			Join Pessoa PP on PP.cd_pes=cd_import_hia
			Join Cta_Cte_hou_imp_aer CTA on CTA.num_proc_hia=HOU.num_proc_hia and CTA.cd_tp_tx in ('DES','DLV') and cta.dc_hia='C' and Comp_RP_HIA='S'
			Left Join caixa_hou_imp_Aer CXA on CTA.num_proc_hia=CXA.num_proc_hia and CTA.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_hia=CXA.dc_hia and num_lcto <> 'PROVISÓRIO'
			Join Localidade Org on Org.cd_local=cd_org_hia
			Left Join Hist_geral hsg on hsgprocesso=hou.num_proc_hia and cd_tp_ocor=43
		Where 
			(CXA.num_lcto is null and CTA.num_proc_hia is not null) 
			and left(hou.num_proc_hia,5) <> 'IAJOB' AND PAIS_LOCAL IN ('EUA')
			and (hsddescricao not like '%Excluir%' OR hsddescricao IS NULL)
		GROUP BY
			HOU.num_proc_hia, hawb_hia, Nome_Raz_soc, Convert(Datetime,dt_cheg_mia,105) , cd_org_hia , Vlr_Frete_Efet_HIA, Tp_Frete_HIA 
		Order by
			Convert(Datetime,dt_cheg_mia,105) 
	END

if @intstatus=0
	
	BEGIN


		select 
			HOU.num_proc_hia, hawb_hia, Upper(Nome_Raz_soc) Cliente, 
			Convert(Datetime,dt_cheg_mia,105) Data, upper(cd_org_hia) ORG, 
			Vlr_Frete_Efet_HIA, Tp_Frete_HIA,max(hsdDescricao) Obs  
		from 
			house_imp_aer HOU
			Join Master_imp_aer MAS on MAS.num_proc_mia=HOU.num_proC_mia
			Join Pessoa PP on PP.cd_pes=cd_import_hia
			Join Cta_Cte_hou_imp_aer CTA on CTA.num_proc_hia=HOU.num_proc_hia and CTA.cd_tp_tx in ('DES','DLV') and cta.dc_hia='C' and Comp_RP_HIA='S'
			Left Join caixa_hou_imp_Aer CXA on CTA.num_proc_hia=CXA.num_proc_hia and CTA.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_hia=CXA.dc_hia and num_lcto <> 'PROVISÓRIO'
			Join Localidade Org on Org.cd_local=cd_org_hia
			Left Join Hist_geral hsg on hsgprocesso=hou.num_proc_hia and cd_tp_ocor=43
			
		Where 
			(CXA.num_lcto is null and CTA.num_proc_hia is not null) 
			and left(hou.num_proc_hia,5) <> 'IAJOB' AND PAIS_LOCAL not IN ('EUA')
			and (hsddescricao not like '%Excluir%' OR hsddescricao IS NULL)
		GROUP BY
			HOU.num_proc_hia, hawb_hia, Nome_Raz_soc, Convert(Datetime,dt_cheg_mia,105) , cd_org_hia , Vlr_Frete_Efet_HIA, Tp_Frete_HIA 
		order by
			Convert(Datetime,dt_cheg_mia,105) 
	END

else

	BEGIN


		select 
			HOU.num_proc_hia, hawb_hia, Upper(Nome_Raz_soc) Cliente, 
			Convert(Datetime,dt_cheg_mia,105) Data, upper(cd_org_hia) ORG, 
			Vlr_Frete_Efet_HIA, Tp_Frete_HIA,max(hsdDescricao) Obs  
		from 
			house_imp_aer HOU
			Join Master_imp_aer MAS on MAS.num_proc_mia=HOU.num_proC_mia
			Join Pessoa PP on PP.cd_pes=cd_import_hia
			Join Cta_Cte_hou_imp_aer CTA on CTA.num_proc_hia=HOU.num_proc_hia and CTA.cd_tp_tx in ('DES','DLV') and cta.dc_hia='C' and Comp_RP_HIA='S'
			Left Join caixa_hou_imp_Aer CXA on CTA.num_proc_hia=CXA.num_proc_hia and CTA.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_hia=CXA.dc_hia and num_lcto <> 'PROVISÓRIO'
			Join Localidade Org on Org.cd_local=cd_org_hia
			Left Join Hist_geral hsg on hsgprocesso=hou.num_proc_hia and cd_tp_ocor=43
		Where 
			(CXA.num_lcto is null and CTA.num_proc_hia is not null) 
			and left(hou.num_proc_hia,5) <> 'IAJOB' 
			and (hsddescricao not like '%Excluir%' OR hsddescricao IS NULL)
		GROUP BY
			HOU.num_proc_hia, hawb_hia, Nome_Raz_soc, Convert(Datetime,dt_cheg_mia,105) , cd_org_hia , Vlr_Frete_Efet_HIA, Tp_Frete_HIA 
		Order by
		Convert(Datetime,dt_cheg_mia,105) 
	END





GO
