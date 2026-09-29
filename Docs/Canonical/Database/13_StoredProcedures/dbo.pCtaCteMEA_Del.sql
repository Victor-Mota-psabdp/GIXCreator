SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE pCtaCteMEA_Del 
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
@Usuario			VarChar(6),
@Comp_MBL_MEA		char(1)='N',
@IntDefinitiva			int=null
)
--Parâmetros de Retorno 
--(1) Procedimento concluído com exito 
--(-1) Violação de Chave 
--(-2) Erro no Procedimento 
--(-3) Erro na Inserção do Log 
--(-4) Ja existe baixa - Impossível Excluir 
 AS
	Begin Transaction  
	Declare @NF VarChar(30) 
	Declare @Dt_Ins DateTime
	Declare @Vlr_Contab	decimal(12,2)
	Declare @Grupo	varchar(10) 	

	Set @Grupo = IsNull((Select Grupo From Usuario Where Cd_Usuario = @Usuario),'')
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

	Set @Vlr_Contab = IsNull((Select Val_Con_Comp from Cta_Cte_Mas_Exp_Aer Where  Num_Proc_MEA = @Num_Proc_MEA and Cd_Tp_Tx =@Cd_Tp_Tx and DC_MEA = @DC_MEA), 0)
--	If (@Vlr_Contab > 0 )
--		Begin 
--			RollBack Transaction 
--			Return -12
--		End 
	if @IntDefinitiva = 0 
		Set @Vlr_Contab =  null 


	If  Exists(Select Num_Proc_MEA from Cta_Cte_Mas_Exp_Aer Where  Num_Proc_MEA = @Num_Proc_MEA and Cd_Tp_Tx =@Cd_Tp_Tx and DC_MEA = @DC_MEA) 
		Begin 
			If Not Exists (Select  * From  Caixa_Mas_Exp_Aer Where Num_Proc_MEA = @Num_Proc_MEA and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_MEA = @DC_MEA ) 
				Begin 
					Delete From 
						Cta_Cte_Mas_Exp_Aer
					Where 
						Num_Proc_MEA = @Num_Proc_MEA and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_MEA = @DC_MEA
					If @@RowCount  = 1  	
						Begin 
							Delete From 
								Cta_Cte_Hou_Exp_Aer
							Where 
								Num_Proc_HEA = left(@Num_Proc_MEA,14) and 
								Cd_Tp_Tx = @Cd_Tp_Tx and 
								DC_HEA = @DC_MEA
							Exec pLogCtaCte_Ins  
								'E', @Num_Proc_MEA, @Cd_Tp_Tx,@DC_MEA, @Org_Ins_MEA,@Dt_Ins_MEA, @Cd_Tp_Moeda, 
								@Vlr_Org_MEA, @Dt_Prev_Pgto_MEA,@Cd_Cred_Dev_MEA, @Desp_Dst_MEA,@CPMF_MEA,@Comp_RP_MEA, 
								@Comp_DN_MEA, @Comp_CN_MEA, @Comp_CPA_MEA, @Usuario, @Vlr_Contab
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
			Else
				Begin 
					Rollback Transaction 
					Return - 4 
				End 
		End 
	Else
		Begin 
			Rollback Transaction 
			Return - 1 
		End
GO
