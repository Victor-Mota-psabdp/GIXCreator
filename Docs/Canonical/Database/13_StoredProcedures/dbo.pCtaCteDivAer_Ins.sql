SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pCtaCteDivAer_Ins 
(
@Cd_Tp_Tx			varchar(3),
@DC_HIA			char(1),
@Org_Ins_HIA			varchar(9),
@Dt_Ins_HIA			varchar(10), 
@Cd_Tp_Moeda		varchar(3), 
@Vlr_Org_HIA			float, 
@Dt_Prev_Pgto_HIA		varchar(10)='', 
@Cd_Cred_Dev_HIA		varchar(10), 
@Desp_Org_HIA		char(1)='N',
@CPMF_HIA			char(1)='N', 
@Comp_RP_HIA		char(1)='N', 
@Comp_DN_HIA		char(1)='N',
@Comp_CN_HIA		char(1)='N',
@Comp_CPA_HIA		char(1)='N', 
@Num_DCN_HIA		varchar(12)=Null, 
@Dt_Ctb_CC_HIA		varchar(10)=Null,
@Usuario			Varchar(6), 
@Referencia 			VarChar(16) = Null Output, 
@HAWB 			VarChar(25) = Null Output 
)
--Parâmetros de Retorno 
--(1) Procedimento concluído com exito 
--(-1) Violação de Chave 
--(-2) Erro no Procedimento 
--(-3) Erro na Inserção do Log 
--(-4) Erro na Inserção do BL
 AS

	Declare @Mes		Char(2)
	Begin Transaction  
		Set @Mes =  Cast(month(GetDate()) as Char(2))
		If Len(@Mes) = 1 
			Set @Mes = '0' +  Cast(month(GetDate()) as Char(2))

		Set @Referencia = IsNull((Select Max(Right(Num_Proc_HIA, 3))  From House_Imp_Aer Where Left(Num_Proc_HIA, 11) = 'IAREM' + Cast(Year(GetDate()) as Char(4)) + @Mes),0) + 1 			
		If Len(@Referencia) = 1 
			Set @Referencia  = '00' + @Referencia 
		If Len(@Referencia) = 2 
			Set @Referencia  = '0' + @Referencia 			
		
		Set @Referencia = 'IAREM' +  Cast(year(GetDate()) as Char(4)) +@Mes +  @Referencia

		Set @HAWB = IsNull((Select Max(Right(HAWB_HIA, 3))  From House_Imp_Aer  Where Left(HAWB_HIA, 15) = 'BDP-DSP-AER' + Right(Cast(Year(GetDate()) as Char(4)),2) + @Mes),0) + 1 
		If Len(@HAWB) = 1 
			Set @HAWB  = '00' + @HAWB
		If Len(@HAWB) = 2 
			Set @HAWB  = '0' + @HAWB
		
		Set @HAWB = 'BDP-DSP-AER-' + Right(Cast(year(GetDate()) as Char(4)),2) +@Mes +  @HAWB

		Insert into House_Imp_Aer
			(Num_Proc_HIA, Num_Proc_MIA, Dt_Emis_HIA, Cd_Tp_Etapa, HAWB_HIA, MAWB_HIA, Cd_Import_HIA,
			Cd_Consig_HIA, Cd_Export_HIA, Voo_HIA, Cd_Org_HIA, Cd_Dst_HIA, ETD_HIA, ETA_HIA, Qtd_Tot_Vol_HIA, Peso_Real_HIA, 
			Tp_Frete_HIA, Cd_Tp_Moeda, Vlr_Frete_Efet_HIA, Back_Back_HIA, Prod_Perig_HIA, Prod_Perec_HIA, Cli_Msq_HIA, Dt_Pri_Avs_HIA, 
			EW_HIA, FOB_FCA_HIA, CIF_HIA, Vol_Tot_HIA, Peso_Bruto_HIA,  Trf_Cp_HIA, Trf_Vd_HIA, Vlr_Frete_Negoc_HIA)
		Values 
			(@Referencia, 'IAREM200001001', '01/01/2000', 'UNC', @HAWB, 'BDP-DSP-AER-0305001', '10017',
			'10017', '10017', 'DSP', 'MIA', 'SSZ', '01/01/2000', '01/01/2000', 0, 0, 
			'P', 'USD', 0, 'N', 'N', 'N', 'N', Null, 'N', 'N', 'N', 0, 0,  Null, Null, 0)

		If @@RowCount <> 1 
			Begin 
				RollBack Transaction 
				Return -4 
			End 
		Begin 
			Insert into  
				Cta_Cte_Hou_Imp_Aer
				(Num_Proc_HIA,Cd_Tp_Tx,DC_HIA,Org_Ins_HIA,Dt_Ins_HIA,Cd_Tp_Moeda,Vlr_Org_HIA,Dt_Prev_Pgto_HIA, 
				Cd_Cred_Dev_HIA,Desp_Org_HIA,CPMF_HIA,Comp_RP_HIA, Comp_DN_HIA, Comp_CN_HIA, Comp_CPA_HIA, 
				Num_DCN_HIA,Dt_Ctb_CC_HIA)
			Values 	
				( @Referencia, @Cd_Tp_Tx,@DC_HIA, @Org_Ins_HIA,@Dt_Ins_HIA, @Cd_Tp_Moeda, @Vlr_Org_HIA, 
				@Dt_Prev_Pgto_HIA,@Cd_Cred_Dev_HIA, @Desp_Org_HIA,@CPMF_HIA,@Comp_RP_HIA, @Comp_DN_HIA, 
				@Comp_CN_HIA, @Comp_CPA_HIA, @Num_DCN_HIA,@Dt_Ctb_CC_HIA)

			If @@RowCount  = 1  	
				Begin 
					Exec pLogCtaCte_Ins 
						'I', @Referencia, @Cd_Tp_Tx,@DC_HIA, @Org_Ins_HIA,@Dt_Ins_HIA, @Cd_Tp_Moeda, 
						@Vlr_Org_HIA, @Dt_Prev_Pgto_HIA,@Cd_Cred_Dev_HIA, @Desp_Org_HIA,@CPMF_HIA,@Comp_RP_HIA, 
						@Comp_DN_HIA, @Comp_CN_HIA, @Comp_CPA_HIA, @usuario 
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
			
		End
GO
