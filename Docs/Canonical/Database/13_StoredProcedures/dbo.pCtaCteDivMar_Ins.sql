SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pCtaCteDivMar_Ins 
(
@Cd_Tp_Tx			varchar(3),
@DC_HIM			char(1),
@Org_Ins_HIM			varchar(9),
@Dt_Ins_HIM			varchar(10), 
@Cd_Tp_Moeda		varchar(3), 
@Vlr_Org_HIM			float, 
@Dt_Prev_Pgto_HIM		varchar(10)='', 
@Cd_Cred_Dev_HIM		varchar(10), 
@Desp_Org_HIM		char(1)='N',
@CPMF_HIM			char(1)='N', 
@Comp_RP_HIM		char(1)='N', 
@Comp_DN_HIM		char(1)='N',
@Comp_CN_HIM		char(1)='N',
@Comp_CPA_HIM		char(1)='N', 
@Num_DCN_HIM		varchar(12)=Null, 
@Dt_Ctb_CC_HIM		varchar(10)=Null,
@Usuario			Varchar(6),
@Referencia 			VarChar(16) = Null Output, 
@HAWB 			VarChar(25) = Null Output 
)
--Parâmetros de Retorno 
--(1) Procedimento concluído com exito 
--(-1) Violação de Chave 
--(-2) Erro no Procedimento 
--(-3) Erro na Inserção do Log 
 AS
	Begin Transaction  
	Declare @Mes	Char(2)
	Declare @Prefix varchar(11)

	Set @Mes =  Cast(month(GetDate()) as Char(2))
	If Len(@Mes) = 1 
		Set @Mes = '0' +  Cast(month(GetDate()) as Char(2))

	Set @Referencia = IsNull((Select Max(Right(Num_Proc_HIM, 3))  From House_Imp_Mar Where Left(Num_Proc_HIM, 11) = 'IMREM' + Cast(Year(GetDate()) as Char(4)) + @Mes),0) + 1 			
	If Len(@Referencia) = 1 
		Set @Referencia  = '00' + @Referencia 
	If Len(@Referencia) = 2 
		Set @Referencia  = '0' + @Referencia 			

	Set @Referencia = 'IMREM' +  Cast(year(GetDate()) as Char(4)) +@Mes +  @Referencia

	Set @HAWB = IsNull((Select Max(Right(HAWB_HIM, 3))  From House_Imp_Mar  Where Left(HAWB_HIM, 15) = 'BDP-DSP-MAR' + Right(Cast(Year(GetDate()) as Char(4)),2) + @Mes),0) + 1 
	If Len(@HAWB) = 1 
		Set @HAWB  = '00' + @HAWB
	If Len(@HAWB) = 2 
		Set @HAWB  = '0' + @HAWB
	
	Set @HAWB = 'BDP-DSP-MAR' + Right(Cast(year(GetDate()) as Char(4)),2) +@Mes +  @HAWB

	Insert Into 
		House_Imp_Mar 
		(Num_Proc_HIM, Num_Proc_MIM, Num_Prop_IM, Dt_Emis_HIM, HAWB_HIM, MAWB_HIM, Cd_Import_HIM, Cd_Consig_HIM, 
		 Cd_Export_HIM, Navio_HIM, Viagem_HIM, Id_Viagem, Band_Bras_HIM, Cd_Org_HIM, Cd_Dst_HIM, Dt_Saida_HIM, Dt_Cheg_HIM, 
		Tp_Frete_HIM, Cd_Tp_Moeda, Vlr_Frete_Efet_HIM, Prod_Perig_HIM, Prod_Perec_HIM, Cd_Sb_Ag_Int_HIM, Cd_Sb_Ag_Nac_HIM, 
		Cd_Tp_Prod, EW_HIM, FOB_FCA_HIM, CIF_HIM, Cli_Msq_HIM, Cd_Porto_Rcb_HIM, Cd_Emissor, Cd_Tp_Embal, Qtd_Tot_Vol_HIM, 
		Vol_Tot_HIM, Peso_Liquido_HIM, Peso_Bruto_HIM, Tp_Trf_HIM, Trf_Cp_HIM, Trf_Vd_HIM, Vlr_Frete_Negoc_HIM, Dt_Rcb_Doc_HIM, 
		Dt_Etg_Doc_HIM, Obs_HIM, Transito_HIM)
	Values 
		(@Referencia, 'IMREM200001001', Null, '01/01/2000', @HAWB, 'BDP-DSP-MAR-0305001', '10017', '10017','10017',
		 'Desp', '0000', Null, 'N', 'MIA', 'SSZ', '01/01/2000', '01/01/2000', 'P', 'USD', 0, 'N', 'N', 0, 0, 
		0, 'N', 'N', 'N', 'N', 0, Null, 0, 0, 0, 0, 0, Null, 0, 0, 0, Null, Null, Null, Null)		

	If @@RowCount <> 1 
		Begin 
			RollBack Transaction 
			Return -1 
		End 	

	Insert into  
		Cta_Cte_Hou_Imp_Mar
		(Num_Proc_HIM,Cd_Tp_Tx,DC_HIM,Org_Ins_HIM,Dt_Ins_HIM,Cd_Tp_Moeda,Vlr_Org_HIM,Dt_Prev_Pgto_HIM, 
		Cd_Cred_Dev_HIM,Desp_Org_HIM,CPMF_HIM,Comp_RP_HIM, Comp_DN_HIM, Comp_CN_HIM, Comp_CPA_HIM, 
		Num_DCN_HIM,Dt_Ctb_CC_HIM)
	Values 	
		( @Referencia, @Cd_Tp_Tx,@DC_HIM, @Org_Ins_HIM,@Dt_Ins_HIM, @Cd_Tp_Moeda, @Vlr_Org_HIM, 
		@Dt_Prev_Pgto_HIM,@Cd_Cred_Dev_HIM, @Desp_Org_HIM,@CPMF_HIM,@Comp_RP_HIM, @Comp_DN_HIM, 
		@Comp_CN_HIM, @Comp_CPA_HIM, @Num_DCN_HIM,@Dt_Ctb_CC_HIM)
	If @@RowCount  = 1  	
		Begin 
			Exec pLogCtaCte_Ins 
				'I', @Referencia, @Cd_Tp_Tx,@DC_HIM, @Org_Ins_HIM,@Dt_Ins_HIM, @Cd_Tp_Moeda, 
				@Vlr_Org_HIM, @Dt_Prev_Pgto_HIM,@Cd_Cred_Dev_HIM, @Desp_Org_HIM,@CPMF_HIM,@Comp_RP_HIM, 
				@Comp_DN_HIM, @Comp_CN_HIM, @Comp_CPA_HIM, @usuario 
			If @@RowCount = 1 
				Begin 
					Commit Transaction
					Return 1 
				End 
			Else
				Begin 
					RollBack Transaction 
					Return -3
				End 
		End 
	Else
		Begin 
			Rollback Transaction 
			Return - 2 
		End
GO
