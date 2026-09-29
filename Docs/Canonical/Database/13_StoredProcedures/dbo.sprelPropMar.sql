SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure sprelPropMar

		@datainicial 	varchar(10),
		@datafinal	varchar(10),
		@pessoa		varchar(30),
		@modal		varchar(2)
as

if @modal='IM'
	BEGIN
		select 
			apelido, convert(datetime, dt_msg_pim, 105)as Data, pop.obs_pim, origem.nome_local as DE, destino.nome_local as PARA, nome_armador, tr.cd_tp_moeda, 
			tp_trf_tnim as Tipo,trf_vd_1_tnim as Primeiro, trf_vd_2_tnim as Segundo, trf_vd_3_tnim as Terceiro, trf_vd_4_tnim as Quarta, trf_vd_5_tnim as Quinta
			,trf_vd_6_tnim as Sexta, trf_vd_7_tnim as Setimo, trf_vd_8_tnim as Oitavo,
			trf_vd_9_tnim as Nona, trf_vd_10_tnim as Dez, trf_vd_11_tnim as onze,
			trf_vd_12_tnim as Doze, trf_vd_13_tnim as Treze, trf_vd_14_tnim as Quatorze,
			Trst_Time_TNIM, Freq_TNIM, Obs_TNIM 

		from 
			proposta_imp_mar as pop


		inner join tarifa_neg_IMP_mar as tr on (pop.NUM_PROP_Im=tr.NUM_PROP_Im)
		inner join taxa_neg_IMP_mar as tx on (pop.NUM_PROP_Im=tx.NUM_PROP_Im)
		inner join pessoa as pp on (pop.CD_IMPORT_pim=cd_pes)
		inner join tipo_taxa as tt on (tt.cd_tp_tx=tx.cd_tp_tx)
		inner join localidade as origem on (origem.cd_local=tr.cd_org_tnim)
		inner join localidade as destino on (destino.cd_local=tr.cd_dst_tnim)
		inner join armador as  arm on (arm.cd_armador=tr.cd_armador)
		
		Where 
			apelido like @pessoa 
			and convert(datetime,  dt_msg_pim, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
	END
else
	
	Begin
		select 
			apelido, convert(datetime, dt_msg_pem, 105)as Data, pop.obs_pem, origem.nome_local as DE, destino.nome_local as PARA, nome_armador, tr.cd_tp_moeda, 
			tp_trf_tnem as Tipo,trf_vd_1_tnem as Primeiro, trf_vd_2_tnem as Segundo, trf_vd_3_tnem as Terceiro, trf_vd_4_tnem as Quarta, trf_vd_5_tnem as Quinta
			,trf_vd_6_tnem as Sexta, trf_vd_7_tnem as Setimo, trf_vd_8_tnem as Oitavo,
			trf_vd_9_tnem as Nona, trf_vd_10_tnem as Dez, trf_vd_11_tnem as onze,
			trf_vd_12_tnem as Doze, trf_vd_13_tnem as Treze, trf_vd_14_tnem as Quatorze,
			Trst_Time_tnem, Freq_tnem, Obs_tnem 

		from 
			proposta_exp_mar as pop


		inner join tarifa_neg_exp_mar as tr on (pop.NUM_prop_em=tr.NUM_prop_em)
		inner join taxa_neg_exp_mar as tx on (pop.NUM_prop_em=tx.NUM_prop_em)
		inner join pessoa as pp on (pop.CD_expORT_pem=cd_pes)
		inner join tipo_taxa as tt on (tt.cd_tp_tx=tx.cd_tp_tx)
		inner join localidade as origem on (origem.cd_local=tr.cd_org_tnem)
		inner join localidade as destino on (destino.cd_local=tr.cd_dst_tnem)
		inner join armador as  arm on (arm.cd_armador=tr.cd_armador)
		
		Where 
			apelido like @pessoa 
			and convert(datetime,  dt_msg_pem, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
	END		 

GO
