SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spHAWB_IA_Rel] --'','',''
	@Processo 	VarChar(16),
	@User		varchar(50),
	@Tipo		char(1)

AS

	Declare @Vlr_Agt_HIA	Varchar(50)
	Declare @Vlr_Crr_HIA 	Varchar(50)
	Declare @Vlr_Tx_Tot_HIA Varchar(50)

	Set @Vlr_Agt_HIA=(select sum(vlr_org_HIA)from cta_cte_HOU_Imp_aer where num_proc_HIA = @Processo and Comp_Job_HIA = 'A')
	Set @Vlr_Crr_HIA=(select sum(vlr_org_HIA)from cta_cte_HOU_Imp_aer where num_proc_HIA = @Processo and Comp_Job_HIA = 'C')
	Set @Vlr_Tx_Tot_HIA= cast(@Vlr_Agt_HIA as decimal(10,2)) + cast(@Vlr_Crr_HIA as decimal(10,2))

	select 
		HOU.Num_Proc_HIA,
		MAWB_HIA, 
		HAWB_HIA,
		SH.Num_CPF_CNPJ RUT_Shipper,
		sh.Nome_raz_soc Shipper,
		ENDS.RUA RUA_S, 
		ENDS.Bairro BAIRRO_S, 
		ENDS.Cidade CIDADE_S, 
		UPPER(ENDS.Pais) Pais_S,
		cs.Nome_Raz_Soc Consignee,
		ENDC.RUA RUA_C, 
		ENDC.Bairro BAIRRO_C, 
		ENDC.Cidade CIDADE_C, 
		UPPER(ENDS.Pais) Pais_C,
		AG.Nome_raz_soc Agente, 
		ENDA.RUA RUA_A, 
		ENDA.Bairro BAIRRO_A, 
		ENDA.Cidade CIDADE_A, 
		UPPER(ENDA.Pais) Pais_A,
 		( 'FILE: ' + @Processo) Accounting ,
		UPPER(LCO.Nome_Local) Origem, 
		LCO.cd_local CD_Origem, 
		CA.Nome_cia_aer Cia_Aer,
		CA.Cd_cia_aer CD_CIA_AER,
		MIA.Voo_MIA Voo_MIA,
		MIA.cd_tp_moeda,
		tp_frete_HIA, 
		UPPER(LCD.Nome_Local) Destino,  
		LLP.ATD_LIA DATA_SAIDA,
--		HN.Hand_HIA_1,
		Qtd_Tot_Vol_HIA,
		Peso_Bruto_HIA PESO_BRUTO,
		LLP.Peso_Cubado_LIA PESO_CUBADO, 
		vlr_frete_efet_HIA VALOR_FRETE,
		NG.Descr NATURES_GOODS,
		left(HOU.MAWB_HIA,3) COMECO,
		right(HOU.MAWB_HIA,8) FIM,
		@Vlr_Agt_HIA Valor_Agente,
		@Vlr_Crr_HIA Valor_Carrier,
		@Vlr_Tx_Tot_HIA Total_Taxa,
		dbo.spTaxasEA(@Processo) Taxas,
		Obs_HIA
	from 
		house_Imp_Aer HOU
		Left Join Master_Imp_Aer MIA on HOU.num_proc_mia = MIA.num_proc_mia
		Left Outer Join LLP_Imp_Aer LLP on HOU.Num_Proc_HIA = LLP.Num_Proc_LIA
		Left Join Pessoa AG on MIA.cd_export_mia = AG.cd_pes
		Left Join Endereco ENDA on MIA.cd_export_mia = ENDA.cd_pes and ENDA.cd_tp_end = 'COM'
		Left Join Cia_Aerea CA on MIA.cd_cia_aer = CA.cd_cia_aer
		Left Join Pessoa NF on NF.cd_pes=cd_export_HIA
		Left Join Pessoa CS on CS.cd_pes=cd_consig_HIA
		Left Join Endereco ENDC on CS.cd_pes=ENDC.cd_pes and ENDC.cd_tp_end = 'COM'
		Left Join Pessoa Sh on SH.cd_pes=cd_export_HIA
		Left Join Endereco ENDS on SH.cd_pes=ENDS.cd_pes and ENDC.cd_tp_end = 'COM'
		Join Tipo_Moeda TM on TM.cd_tp_moeda=HOU.cd_tp_moeda
		Left Join nature_goods NG on HOU.num_proc_HIA=NG.Num_Proc
	--	Left Join Handling_HIA HN on Hou.num_proc_HIA = HN.Num_proc_HIA 
		Left Join PESSOA DSP on cd_dsp_HIA=DSP.cd_pes
		Left Join Localidade LCO on HOU.cd_org_HIA = LCO.cd_local
		Left Join Localidade LCD on Hou.cd_dst_HIA = LCD.cd_local
	Where
		hou.Num_Proc_HIA=@Processo












GO
