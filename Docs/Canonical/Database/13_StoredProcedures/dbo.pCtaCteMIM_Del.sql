SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pCtaCteMIM_Del 
(
@Num_Proc_MIM		varchar(16), 
@Cd_Tp_Tx			varchar(3),
@DC_MIM			char(1),
@Org_Ins_MIM			varchar(9),
@Dt_Ins_MIM			varchar(10), 
@Cd_Tp_Moeda		varchar(3), 
@Vlr_Org_MIM			Float, 
@Dt_Prev_Pgto_MIM		varchar(10), 
@Cd_Cred_Dev_MIM		varchar(10), 
@Desp_Dst_MIM		char(1),
@CPMF_MIM			char(1), 
@Comp_RP_MIM		char(1), 
@Comp_DN_MIM		char(1),
@Comp_CN_MIM		char(1),
@Comp_CPA_MIM		char(1), 
@Num_DCN_MIM		varchar(12)=Null, 
@Dt_Ctb_CC_MIM		varchar(10)=Null,
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
	Declare @Grupo	varchar(10) 	

	Set @NF = IsNull((Select  Num_NF_MIM From  Cta_Cte_Mas_Imp_Mar Where Num_Proc_MIM = @Num_Proc_MIM and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_MIM = @DC_MIM ) , '') 
	Set @Grupo = IsNull((Select Grupo From Usuario Where Cd_Usuario = @Usuario),'')

	If @NF <> '' 
		Begin 
			RollBack Transaction 
			Return -9 
		End 

	Set @Dt_Ins = (Select Convert(DateTime, Dt_Ins_MIM, 105) From Cta_Cte_Mas_Imp_Mar  Where Num_Proc_MIM = @Num_Proc_MIM and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_MIM = @DC_MIM )	
	If (@Dt_Ins <> Dbo.Hoje(GetDate()) and  @Grupo <> 'ADMIN')
		Begin 
			RollBack Transaction 
			Return -10
		End 
	Set @Vlr_Contab = IsNull((Select Val_Con_Comp from Cta_Cte_Mas_Imp_Mar Where  Num_Proc_MIM = @Num_Proc_MIM and Cd_Tp_Tx =@Cd_Tp_Tx and DC_MIM = @DC_MIM), 0)
--	If (@Vlr_Contab > 0 )
--		Begin 
--			RollBack Transaction 
--			Return -12
--		End  
	if @IntDefinitiva = 0 
		Set @Vlr_Contab =  null 


	If  Exists(Select Num_Proc_MIM from Cta_Cte_Mas_Imp_Mar Where  Num_Proc_MIM = @Num_Proc_MIM and Cd_Tp_Tx =@Cd_Tp_Tx and DC_MIM = @DC_MIM) 
		Begin 
			If Not Exists (Select  * From  Caixa_Mas_Imp_Mar Where Num_Proc_MIM = @Num_Proc_MIM and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_MIM = @DC_MIM ) 
				Begin 
					Delete From 
						Cta_Cte_Mas_Imp_Mar
					Where 
						Num_Proc_MIM = @Num_Proc_MIM and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_MIM = @DC_MIM
					If @@RowCount  = 1  	
						Begin 
							Delete From 
								Cta_Cte_Hou_Imp_Mar
							Where 
								Num_Proc_HIM = left(@Num_Proc_MIM,14) and 
								Cd_Tp_Tx = @Cd_Tp_Tx and 
								DC_HIM = @DC_MIM
							Exec pLogCtaCte_Ins  
								'E', @Num_Proc_MIM, @Cd_Tp_Tx,@DC_MIM, @Org_Ins_MIM,@Dt_Ins_MIM, @Cd_Tp_Moeda, 
								@Vlr_Org_MIM, @Dt_Prev_Pgto_MIM,@Cd_Cred_Dev_MIM, @Desp_Dst_MIM,@CPMF_MIM,@Comp_RP_MIM, 
								@Comp_DN_MIM, @Comp_CN_MIM, @Comp_CPA_MIM, @Usuario, @Vlr_Contab 
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
