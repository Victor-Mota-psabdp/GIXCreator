SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pCtaCteHIM_Del 
(
@Num_Proc_HIM		varchar(16), 
@Cd_Tp_Tx			varchar(3),
@DC_HIM			char(1),
@Org_Ins_HIM			varchar(9),
@Dt_Ins_HIM			varchar(10), 
@Cd_Tp_Moeda		varchar(3), 
@Vlr_Org_HIM			Float, 
@Dt_Prev_Pgto_HIM		varchar(10), 
@Cd_Cred_Dev_HIM		varchar(10), 
@Desp_Org_HIM		char(1),
@CPMF_HIM			char(1), 
@Comp_RP_HIM		char(1), 
@Comp_DN_HIM		char(1),
@Comp_CN_HIM		char(1),
@Comp_CPA_HIM		char(1), 
@Num_DCN_HIM		varchar(12)=Null, 
@Dt_Ctb_CC_HIM		varchar(10)=Null,
@Usuario			VarChar(6),
@Sys				bit = 0 ,
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
	Declare @Grupo	varchar(10)
	Declare @Vlr_Contab	decimal(12,2)

	Set @Grupo = IsNull((Select Grupo From Usuario Where Cd_Usuario = @Usuario),'')
	Set @JOB = IsNull((Select JOB_HIM From House_Imp_Mar Where Num_Proc_HIM = @Num_Proc_HIM),  '')
	If @Job <> '' and @Num_Proc_HIM <> @JOB 
		Begin 
			Set @chkjob = (Select Comp_Job_HIM From Cta_Cte_Hou_Imp_Mar Where Num_Proc_HIM = @Num_Proc_HIM and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIM = @DC_HIM) 
			if @chkjob = 'S' and @Grupo <>'ADMIN'
				Begin 
					Rollback Transaction 
					Return -31 
				End 
		End 


	Set @NF = IsNull((Select  Num_NF_HIM From  Cta_Cte_Hou_Imp_Mar Where Num_Proc_HIM = @Num_Proc_HIM and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_HIM = @DC_HIM ) , '') 
	If @NF <> '' and @NF <> '0'
		Begin 
			RollBack Transaction 
			Return -9 
		End 

	Set @Dt_Ins = (Select Convert(DateTime, Dt_Ins_HIM, 105) From Cta_Cte_Hou_Imp_Mar  Where Num_Proc_HIM = @Num_Proc_HIM and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_HIM = @DC_HIM )	
	If (@Dt_Ins <> Dbo.Hoje(GetDate()) and  @Grupo <> 'ADMIN' and Left(@Num_Proc_HIM, 5) <> 'IMJOB' )
		Begin 
			RollBack Transaction 
			Return -10
		End 

	If Exists(select * from item_fat as ifat join fatura fat on  fat.fatcod = ifat.fatcod where fatstatus = 1 and ifat.Num_proc = @Num_Proc_HIM and ifat.cd_tp_Tx = @Cd_Tp_Tx and ifat.dc = @DC_HIM )
		Begin 
			RollBack Transaction 
			Return -11
		End 

	Set @Vlr_Contab = IsNull((Select Val_Con_Comp from Cta_Cte_Hou_Imp_Mar Where  Num_Proc_HIM = @Num_Proc_HIM and Cd_Tp_Tx =@Cd_Tp_Tx and DC_HIM = @DC_HIM), 0)
--	If (@Vlr_Contab > 0 )
--		Begin 
--			RollBack Transaction 
--			Return -12
--		End 

	if @IntDefinitiva = 0 
		Set @Vlr_Contab =  null 


	If  Exists(Select Num_Proc_HIM from Cta_Cte_Hou_Imp_Mar Where  Num_Proc_HIM = @Num_Proc_HIM and Cd_Tp_Tx =@Cd_Tp_Tx and DC_HIM = @DC_HIM) 
		Begin 
			If Not Exists (Select  * From  Caixa_Hou_Imp_Mar Where Num_Proc_HIM = @Num_Proc_HIM and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_HIM = @DC_HIM ) 
				Begin 
					Delete From 
						Cta_Cte_Hou_Imp_Mar
					Where 
						Num_Proc_HIM = @Num_Proc_HIM and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_HIM = @DC_HIM
					If @@RowCount  = 1  	
						Begin 
							Exec pLogCtaCte_Ins  
								'E', @Num_Proc_HIM, @Cd_Tp_Tx,@DC_HIM, @Org_Ins_HIM,@Dt_Ins_HIM, @Cd_Tp_Moeda, 
								@Vlr_Org_HIM, @Dt_Prev_Pgto_HIM,@Cd_Cred_Dev_HIM, @Desp_Org_HIM,@CPMF_HIM,@Comp_RP_HIM, 
								@Comp_DN_HIM, @Comp_CN_HIM, @Comp_CPA_HIM, @Usuario, @Vlr_Contab 
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
