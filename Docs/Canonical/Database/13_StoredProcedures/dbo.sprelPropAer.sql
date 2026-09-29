SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure sprelPropAer

		@datainicial	varchar(10),
		@datafinal	varchar(10),
		@pessoa		varchar(30),
		@modal		varchar(2)
as

if @modal='EA'
	BEGIN 
		SELECT 
			apelido ,pop.num_prop_ea, convert(datetime, dt_msg_pea, 105)as Data, pop.obs_pea, origem.nome_local as DE, destino.nome_local as PARA, nome_cia_aer,
			tr.cd_tp_moeda,tp_trf_Tnea as Tipo, trf_vd_1_tnea as Primeira,   trf_vd_2_tnea as Segunda,  trf_vd_3_tnea as Terceira ,trf_vd_4_tnea as Quarta,  trf_vd_5_tnea as Quinta,  
			trf_vd_6_tnea as Sexta,  trf_vd_7_tnea as Setima,  trf_vd_8_tnea as Oitava, trst_time_tnea, freq_tnea, obs_tnea
		FROM 
			proposta_exp_aer as pop

		inner join tarifa_neg_exp_aer as tr on (pop.num_prop_ea=tr.num_prop_ea)
		inner join taxa_neg_exp_aer as tx on (pop.num_prop_ea=tx.num_prop_ea)
		inner join pessoa as pp on (pop.cd_export_PEA=cd_pes)
		inner join tipo_taxa as tt on (tt.cd_tp_tx=tx.cd_tp_tx)
		inner join localidade as origem on (origem.cd_local=tr.cd_org_tnea)
		inner join localidade as destino on (destino.cd_local=tr.cd_dst_tnea)
		inner join cia_aerea as cia on (cia.cd_cia_aer=tr.cd_cia_aer)

		where apelido like @pessoa 
		and convert(datetime, dt_msg_pea, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
	END
ELSE
	BEGIN	

		SELECT 
			apelido ,pop.NUM_PROP_IA, convert(datetime, dt_msg_PIA, 105)as Data, pop.obs_PIA, origem.nome_local as DE, destino.nome_local as PARA, nome_cia_aer,
			tr.cd_tp_moeda,tp_trf_TNIA as Tipo, trf_vd_1_TNIA as Primeira,   trf_vd_2_TNIA as Segunda,  trf_vd_3_TNIA as Terceira ,trf_vd_4_TNIA as Quarta,  trf_vd_5_TNIA as Quinta,  
			trf_vd_6_TNIA as Sexta,  trf_vd_7_TNIA as Setima,  trf_vd_8_TNIA as Oitava, trst_time_TNIA, freq_TNIA, obs_TNIA
		FROM 
			proposta_IMP_aer as pop

		inner join tarifa_neg_IMP_aer as tr on (pop.NUM_PROP_IA=tr.NUM_PROP_IA)
		inner join taxa_neg_IMP_aer as tx on (pop.NUM_PROP_IA=tx.NUM_PROP_IA)
		inner join pessoa as pp on (pop.CD_IMPORT_PIA=cd_pes)
		inner join tipo_taxa as tt on (tt.cd_tp_tx=tx.cd_tp_tx)
		inner join localidade as origem on (origem.cd_local=tr.cd_org_TNIA)
		inner join localidade as destino on (destino.cd_local=tr.cd_dst_TNIA)
		inner join cia_aerea as cia on (cia.cd_cia_aer=tr.cd_cia_aer)

		where apelido like @pessoa 
		and convert(datetime, dt_msg_pia, 105) between convert(datetime, @datainicial, 105) and convert(datetime, @datafinal, 105)
	
	END


GO
