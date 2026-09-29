SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pCtaCteMEM_Del 
(
@Num_Proc_MEM		varchar(16), 
@Cd_Tp_Tx			varchar(3),
@DC_MEM			char(1),
@Org_Ins_MEM			varchar(9),
@Dt_Ins_MEM			varchar(10), 
@Cd_Tp_Moeda		varchar(3), 
@Vlr_Org_MEM			Float, 
@Dt_Prev_Pgto_MEM		varchar(10), 
@Cd_Cred_Dev_MEM		varchar(10), 
@Desp_Dst_MEM		char(1),
@CPMF_MEM			char(1), 
@Comp_RP_MEM		char(1), 
@Comp_DN_MEM		char(1),
@Comp_CN_MEM		char(1),
@Comp_CPA_MEM		char(1), 
@Num_DCN_MEM		varchar(12)=Null, 
@Dt_Ctb_CC_MEM		varchar(10)=Null,
@Usuario			VarChar(6),
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
	Declare @Fatura	Varchar(16)
	Declare @Grupo	varchar(10) 

	Set @Grupo = IsNull((Select Grupo From Usuario Where Cd_Usuario = @Usuario),'')
	Set @NF = IsNull((Select  Num_NF_MEM From  Cta_Cte_Mas_Exp_Mar Where Num_Proc_MEM = @Num_Proc_MEM and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_MEM = @DC_MEM ) , '') 
	If @NF <> '' 
		Begin 
			RollBack Transaction 
			Return -9 
		End 

	Set @Dt_Ins = (Select Convert(DateTime, Dt_Ins_MEM, 105) From Cta_Cte_Mas_Exp_Mar  Where Num_Proc_MEM = @Num_Proc_MEM and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_MEM = @DC_MEM )	
	If (@Dt_Ins <> Dbo.Hoje(GetDate()) and  @Grupo <> 'ADMIN')
		Begin 
			RollBack Transaction 
			Return -10
		End 

	Set @Vlr_Contab = IsNull((Select Val_Con_Comp from Cta_Cte_Mas_Exp_Mar Where  Num_Proc_MEM = @Num_Proc_MEM and Cd_Tp_Tx =@Cd_Tp_Tx and DC_MEM = @DC_MEM), 0)
--	If (@Vlr_Contab > 0 )
--		Begin 
--			RollBack Transaction 
--			Return -12
--		End 
	if @IntDefinitiva = 0 
		Set @Vlr_Contab =  null 


	If  Exists(Select Num_Proc_MEM from Cta_Cte_Mas_Exp_Mar Where  Num_Proc_MEM = @Num_Proc_MEM and Cd_Tp_Tx =@Cd_Tp_Tx and DC_MEM = @DC_MEM) 
		Begin 
			If Not Exists (Select  * From  Caixa_Mas_Exp_Mar Where Num_Proc_MEM = @Num_Proc_MEM and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_MEM = @DC_MEM ) 
				Begin 
					Delete From 
						Cta_Cte_Mas_Exp_Mar
					Where 
						Num_Proc_MEM = @Num_Proc_MEM and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_MEM = @DC_MEM
					If @@RowCount  = 1  	
						Begin 
							Delete From 
								Cta_Cte_Hou_Exp_Mar
							Where 
								Num_Proc_HEM = left(@Num_Proc_MEM,14) and 
								Cd_Tp_Tx = @Cd_Tp_Tx and 
								DC_HEM = @DC_MEM
							Exec pLogCtaCte_Ins  
								'E', @Num_Proc_MEM, @Cd_Tp_Tx,@DC_MEM, @Org_Ins_MEM,@Dt_Ins_MEM, @Cd_Tp_Moeda, 
								@Vlr_Org_MEM, @Dt_Prev_Pgto_MEM,@Cd_Cred_Dev_MEM, @Desp_Dst_MEM,@CPMF_MEM,@Comp_RP_MEM, 
								@Comp_DN_MEM, @Comp_CN_MEM, @Comp_CPA_MEM, @Usuario, @Vlr_Contab 
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
