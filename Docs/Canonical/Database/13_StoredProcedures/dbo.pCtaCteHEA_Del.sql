SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE pCtaCteHEA_Del 
(
@Num_Proc_HEA		varchar(16), 
@Cd_Tp_Tx			varchar(3),
@DC_HEA			char(1),
@Org_Ins_HEA			varchar(9),
@Dt_Ins_HEA			varchar(10), 
@Cd_Tp_Moeda		varchar(3), 
@Vlr_Org_HEA			Float, 
@Dt_Prev_Pgto_HEA		varchar(10), 
@Cd_Cred_Dev_HEA		varchar(10), 
@Desp_Dst_HEA		char(1),
@CPMF_HEA			char(1), 
@Comp_RP_HEA		char(1), 
@Comp_DN_HEA		char(1),
@Comp_CN_HEA		char(1),
@Comp_CPA_HEA		char(1), 
@Num_DCN_HEA		varchar(12)=Null, 
@Dt_Ctb_CC_HEA		varchar(10)=Null,
@Usuario			VarChar(6),
@Comp_HAWB_HEA		char(1),
@Sys				bit = 0,
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
	Declare @JOB Varchar(16) 
	Declare @chkjob	char(1) 
	Declare @Cd_Cliente	varchar(10) 
	Declare @Cd_Area	varchar(3) 
	Declare @Grupo	varchar(10) 
	Declare @Vlr_Contab	decimal(12,2)

	Set @JOB = IsNull((Select JOB_HEA From House_Exp_Aer Where Num_Proc_HEA = @Num_Proc_HEA),  '')
	Set @Grupo = IsNull((Select Grupo From Usuario Where Cd_Usuario = @Usuario),'')


	If @Job <> '' and @Num_Proc_HEA <> @JOB 
		Begin 
			Set @chkjob = (Select Comp_Job_HEA From Cta_Cte_Hou_Exp_Aer Where Num_Proc_HEA = @Num_Proc_HEA and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HEA = @DC_HEA) 
			if @chkjob = 'S'  and @Grupo <>'ADMIN'
				Begin 
					Rollback Transaction 
					Return -31 
				End 


		End 
		
	Set @NF = IsNull((Select  Num_NF_HEA From  Cta_Cte_Hou_Exp_Aer Where Num_Proc_HEA = @Num_Proc_HEA and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_HEA = @DC_HEA ) , '') 
	If @NF <> '' and @NF <> '0'
		Begin 
			RollBack Transaction 
			Return -9 
		End 

	If Exists(select * from item_fat as ifat join fatura fat on  fat.fatcod = ifat.fatcod where fatstatus = 1 and ifat.Num_proc = @Num_Proc_HEA and ifat.cd_tp_Tx = @Cd_Tp_Tx and ifat.dc = @DC_HEA )
		Begin 
			RollBack Transaction 
			Return -11
		End 

	Set @Dt_Ins = (Select Convert(DateTime, Dt_Ins_HEA, 105) From Cta_Cte_Hou_Exp_Aer  Where Num_Proc_HEA = @Num_Proc_HEA and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_HEA = @DC_HEA )	
	If (@Dt_Ins <> Dbo.Hoje(GetDate()) and  @Grupo <> 'ADMIN' and Left(@Num_Proc_HEA, 5) <> 'EAJOB' )
		Begin 
			RollBack Transaction 
			Return -10
		End 

	Set @Vlr_Contab = IsNull((Select Val_Con_Comp from Cta_Cte_Hou_Exp_Aer Where  Num_Proc_HEA = @Num_Proc_HEA and Cd_Tp_Tx =@Cd_Tp_Tx and DC_HEA = @DC_HEA), 0)
--	If (@Vlr_Contab > 0 )
--		Begin 
--			RollBack Transaction 
--			Return -12
--		End 
	if @IntDefinitiva = 0 
		Set @Vlr_Contab =  null 




	If  Exists(Select Num_Proc_HEA from Cta_Cte_Hou_Exp_Aer Where  Num_Proc_HEA = @Num_Proc_HEA and Cd_Tp_Tx =@Cd_Tp_Tx and DC_HEA = @DC_HEA) 
		Begin 
			If Not Exists (Select  * From  Caixa_Hou_Exp_Aer Where Num_Proc_HEA = @Num_Proc_HEA and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_HEA = @DC_HEA ) 
				Begin 
					Delete From 
						Cta_Cte_Hou_Exp_Aer
					Where 
						Num_Proc_HEA = @Num_Proc_HEA and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_HEA = @DC_HEA
					If @@Error  =  0  	
						Begin 
							Exec pLogCtaCte_Ins  
								'E', @Num_Proc_HEA, @Cd_Tp_Tx,@DC_HEA, @Org_Ins_HEA,@Dt_Ins_HEA, @Cd_Tp_Moeda, 
								@Vlr_Org_HEA, @Dt_Prev_Pgto_HEA,@Cd_Cred_Dev_HEA, @Desp_Dst_HEA,@CPMF_HEA,@Comp_RP_HEA, 
								@Comp_DN_HEA, @Comp_CN_HEA, @Comp_CPA_HEA, @Usuario, @Vlr_Contab 
							If @@Error = 0 
								Begin 
									Commit Transaction
									Return @@RowCount
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
