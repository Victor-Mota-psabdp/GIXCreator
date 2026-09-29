SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE pCtaCteHIA_Upd
(
@Num_Proc_HIA		varchar(16), 
@Cd_Tp_Tx			varchar(3),
@DC_HIA			char(1),
@Org_Ins_HIA			varchar(9),
@Dt_Ins_HIA			varchar(10), 
@Cd_Tp_Moeda		varchar(3), 
@Vlr_Org_HIA			float, 
@Dt_Prev_Pgto_HIA		varchar(10), 
@Cd_Cred_Dev_HIA		varchar(10), 
@Desp_Org_HIA		char(1),
@CPMF_HIA			char(1), 
@Comp_RP_HIA		char(1), 
@Comp_DN_HIA		char(1),
@Comp_CN_HIA		char(1),
@Comp_CPA_HIA		char(1), 
@Num_DCN_HIA		varchar(12)=Null, 
@Dt_Ctb_CC_HIA		varchar(10)=Null,
@Usuario			VarChar(6),
@Sys				bit = 0 ,
@IntDefinitiva			int=null

)
--Parâmetros de Retorno 
--(1) Procedimento concluído com exito 
--(-1) Violação de Chave 
--(-3) Erro na Inserção do Log 
--(-4) Ja existe baixa - Impossível Altera
 AS
	Begin Transaction  
	Declare @NF VarChar(30) 
	Declare @Dt_Ins DateTime
	Declare @Grupo	VarChar(20) 
	Declare @JOB Varchar(16) 
	Declare @chkjob	char(1) 
	Declare @Cd_Area	varchar(3) 
	Declare @Cd_Cliente 	varchar(10)
	Declare @Vlr_Contab 	Decimal(12,2) 
	Declare @Fatura	Varchar(17)
	
	Set @JOB = IsNull((Select JOB_HIA From House_Imp_Aer Where Num_Proc_HIA = @Num_Proc_HIA),  '')
	Set @Cd_Area = IsNull((Select Cd_Area From Usuario Where Cd_Usuario = @Usuario),'') 
	Set @Cd_Cliente = IsNull((Select Cd_Import_HIA From House_Imp_Aer Where Num_Proc_HIA = @Num_Proc_HIA),  '')
	Set @Grupo = (Select Grupo From Usuario Where Cd_Usuario = @Usuario)
	Set @Vlr_Contab = IsNull((Select  Val_Con_Comp From  Cta_Cte_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc_HIA and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_HIA = @DC_HIA ) , 0) 
	Set @Fatura = IsNull((select top 1 itf.fatcod From item_fat itf join fatura fat on fat.fatcod = itf.fatcod where itf.Num_proc = @Num_Proc_HIA and  Itf.Cd_Tp_Tx =@Cd_Tp_Tx AND DC = @DC_HIA and FatStatus <>0 ), '')

	If @Job <> '' and @Num_Proc_HIA <> @JOB 
		Begin 
			Set @chkjob = (Select Comp_Job_HIA From Cta_Cte_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc_HIA and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIA = @DC_HIA) 
			if @chkjob = 'S' and @Grupo <>'ADMIN'
				Begin 
					Rollback Transaction 
					Return -31 
				End 
			if (@Cd_Area <> 'CSR' and @Grupo <>'ADMIN') and  @Cd_Cred_Dev_HIA = @Cd_Cliente
				Begin 
					If @Cd_Tp_Tx not in (Select Cd_Tp_Tx From tipo_taxa_oper)
						begin 
							Rollback Transaction 
							Return -32
						end
				End 
		End 

	--Impedir a inserção de Profit a Débito 
	If @DC_HIA = 'D' and @Cd_Tp_Tx in (Select Cd_Tp_Tx From Tipo_Taxa Where Pft_Aer = 'S') and @Grupo <>'ADMIN'
		Begin
			RollBack Transaction 
			Return - 33
		End 


	Set @NF = IsNull((Select  Num_NF_HIA From  Cta_Cte_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc_HIA and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_HIA = @DC_HIA ) , '') 
	If @NF <> '' and @NF <> '0'
		Begin 
			RollBack Transaction 
			Return -9 
		End 

	Set @Dt_Ins = (Select Convert(DateTime, Dt_Ins_HIA, 105) From Cta_Cte_Hou_Imp_Aer  Where Num_Proc_HIA = @Num_Proc_HIA and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_HIA = @DC_HIA )	
	If (@Dt_Ins <> Dbo.Hoje(GetDate()) and  @Grupo <> 'ADMIN' and Left(@Num_Proc_HIA, 5) <> 'IAJOB' )
		Begin 
			RollBack Transaction 
			Return -10
		End 
	If (@Fatura <> '' )
		Begin 
			RollBack Transaction 
			Return -11
		End 

	If (@Vlr_Contab > 0  )
		Begin 
			RollBack Transaction 
			Return -12
		End 

	If Not Exists (Select  * From  Caixa_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc_HIA and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_HIA = @DC_HIA ) 
		Begin 
			Update 
				Cta_Cte_Hou_Imp_Aer
			Set 	
				Num_Proc_HIA = @Num_Proc_HIA,
				Cd_Tp_Tx = @Cd_Tp_Tx,
				DC_HIA=@DC_HIA,
				Org_Ins_HIA = @Org_Ins_HIA,
				--Dt_Ins_HIA=@Dt_Ins_HIA, 
				Cd_Tp_Moeda=@Cd_Tp_Moeda, 
				Vlr_Org_HIA=@Vlr_Org_HIA, 
				Dt_Prev_Pgto_HIA= @Dt_Prev_Pgto_HIA, 
				Cd_Cred_Dev_HIA=@Cd_Cred_Dev_HIA, 
				Desp_Org_HIA=@Desp_Org_HIA,
				CPMF_HIA=@CPMF_HIA,	
				Comp_RP_HIA=@Comp_RP_HIA, 
				Comp_DN_HIA=@Comp_DN_HIA, 
				Comp_CN_HIA=@Comp_CN_HIA, 
				Comp_CPA_HIA=@Comp_CPA_HIA, 
				Num_DCN_HIA=@Num_DCN_HIA,
				Dt_Ctb_CC_HIA=@Dt_Ctb_CC_HIA
			Where 
				Num_Proc_HIA = @Num_Proc_HIA and 
				Cd_Tp_Tx = @Cd_Tp_Tx and 
				DC_HIA = @DC_HIA
			If @@RowCount  = 1  	
				Begin 
					Exec pLogCtaCte_Ins
						'A', @Num_Proc_HIA, @Cd_Tp_Tx,@DC_HIA, @Org_Ins_HIA,@Dt_Ins_HIA, @Cd_Tp_Moeda, 
						@Vlr_Org_HIA, @Dt_Prev_Pgto_HIA,@Cd_Cred_Dev_HIA, @Desp_Org_HIA,@CPMF_HIA,@Comp_RP_HIA, 
						@Comp_DN_HIA, @Comp_CN_HIA, @Comp_CPA_HIA, @Usuario 
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
					Return - 1 
				End 
		End 
	Else
		Begin 
			Rollback Transaction 
			Return - 4 
		End
GO
