SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE pCtaCteMEA_Upd
(
@Num_Proc_MEA		varchar(16), 
@Cd_Tp_Tx			varchar(3),
@DC_MEA			char(1),
@Org_Ins_MEA			varchar(9),
@Dt_Ins_MEA			varchar(10), 
@Cd_Tp_Moeda		varchar(3), 
@Vlr_Org_MEA			Float, 
@Dt_Prev_Pgto_MEA		varchar(10), 
@Cd_Cred_Dev_MEA		varchar(10), 
@Desp_Dst_MEA		char(1),
@CPMF_MEA			char(1), 
@Comp_RP_MEA		char(1), 
@Comp_DN_MEA		char(1),
@Comp_CN_MEA		char(1),
@Comp_CPA_MEA		char(1), 
@Num_DCN_MEA		varchar(12)=Null, 
@Dt_Ctb_CC_MEA		varchar(10)=Null,
@Usuario			Varchar(6), 
@Comp_MBL_MEA		char(1)='N',
@IntDefinitiva			int=null
)
--Parâmetros de Retorno 
--(-5)  Erro no procedimento de Deleção 
 AS
	Declare @Retorno integer 
	Declare @NF VarChar(30) 
	Declare @Dt_Ins DateTime
	Declare @Grupo	VarChar(20) 
	Declare @Vlr_Contab 	Decimal(12,2) 

	Begin Transaction 
	Set @Grupo = (Select Grupo From Usuario Where Cd_Usuario = @Usuario)
	Set @Vlr_Contab = IsNull((Select  Val_Con_Comp From  Cta_Cte_Mas_Exp_Aer Where Num_Proc_MEA = @Num_Proc_MEA and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_MEA = @DC_MEA ) , 0)


	Set @NF = IsNull((Select  Num_NF_MEA From  Cta_Cte_Mas_Exp_Aer Where Num_Proc_MEA = @Num_Proc_MEA and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_MEA = @DC_MEA ) , '') 
	If @NF <> '' 
		Begin 
			RollBack Transaction 
			Return -9 
		End 

	Set @Dt_Ins = (Select Convert(DateTime, Dt_Ins_MEA, 105) From Cta_Cte_Mas_Exp_Aer  Where Num_Proc_MEA = @Num_Proc_MEA and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_MEA = @DC_MEA )	
	If (@Dt_Ins <> Dbo.Hoje(GetDate()) and  @Grupo <> 'ADMIN')
		Begin 
			RollBack Transaction 
			Return -10
		End 

	If (@Vlr_Contab > 0  )
		Begin 
			RollBack Transaction 
			Return -12
		End 


	If Not Exists (Select * From Caixa_Mas_Exp_Aer Where Num_Proc_MEA = @Num_Proc_MEA and Cd_Tp_Tx = @Cd_Tp_Tx and  DC_MEA = @DC_MEA)
		Begin 
			Update 
				Cta_Cte_Mas_Exp_Aer
			Set 
				Cd_Tp_Tx= @Cd_Tp_Tx,
				DC_MEA = @DC_MEA,
				Org_Ins_MEA = @Org_Ins_MEA,
				--Dt_Ins_MEA = @Dt_Ins_MEA,
				Cd_Tp_Moeda = @Cd_Tp_Moeda,
				Vlr_Org_MEA = @Vlr_Org_MEA, 
				Dt_Prev_Pgto_MEA = @Dt_Prev_Pgto_MEA, 
				Cd_Cred_Dev_MEA = @Cd_Cred_Dev_MEA, 
				Desp_Dst_MEA = @Desp_Dst_MEA, 
				CPMF_MEA = @CPMF_MEA, 
				Comp_RP_MEA = @Comp_RP_MEA, 
				Comp_DN_MEA = @Comp_DN_MEA,
				Comp_CN_MEA = @Comp_CN_MEA,
				Comp_CPA_MEA = @Comp_CPA_MEA, 
				Comp_MBL_MEA = @Comp_MBL_MEA
			Where
				Num_Proc_MEA = @Num_Proc_MEA and 
	 			Cd_Tp_Tx = @Cd_Tp_Tx and 
				DC_MEA = @DC_MEA
			If @@RowCount = 1 
				Exec pLogCtaCte_Ins 
					'E' , @Num_Proc_MEA, @Cd_Tp_Tx,@DC_MEA, @Org_Ins_MEA,@Dt_Ins_MEA, @Cd_Tp_Moeda, 
					@Vlr_Org_MEA, @Dt_Prev_Pgto_MEA,@Cd_Cred_Dev_MEA, @Desp_Dst_MEA,@CPMF_MEA,@Comp_RP_MEA, 
					@Comp_DN_MEA, @Comp_CN_MEA, @Comp_CPA_MEA, @usuario 
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
			RollBack Transaction 
			Return - 4
		End
GO
