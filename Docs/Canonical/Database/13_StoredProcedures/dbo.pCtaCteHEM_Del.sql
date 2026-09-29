SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pCtaCteHEM_Del 
(
@Num_Proc_HEM		varchar(16), 
@Cd_Tp_Tx			varchar(3),
@DC_HEM			char(1),
@Org_Ins_HEM			varchar(9),
@Dt_Ins_HEM			varchar(10), 
@Cd_Tp_Moeda		varchar(3), 
@Vlr_Org_HEM			Float, 
@Dt_Prev_Pgto_HEM		varchar(10), 
@Cd_Cred_Dev_HEM		varchar(10), 
@Desp_Dst_HEM		char(1),
@CPMF_HEM			char(1), 
@Comp_RP_HEM		char(1), 
@Comp_DN_HEM		char(1),
@Comp_CN_HEM		char(1),
@Comp_CPA_HEM		char(1), 
@Num_DCN_HEM		varchar(12)=Null, 
@Dt_Ctb_CC_HEM		varchar(10)=Null,
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
	Declare @Cd_Cliente	varchar(10) 
	Declare @Cd_Area	varchar(3) 
	Declare @Grupo	varchar(10) 
	Declare @Vlr_Contab	decimal(12,2)

	Set @JOB = IsNull((Select JOB_HEM From House_Exp_Mar Where Num_Proc_HEM = @Num_Proc_HEM),  '')
	Set @Grupo = IsNull((Select Grupo From Usuario Where Cd_Usuario = @Usuario),'')


	If @Job <> '' and @Num_Proc_HEM <> @JOB 
		Begin 
			Set @chkjob = (Select Comp_Job_HEM From Cta_Cte_Hou_Exp_Mar Where Num_Proc_HEM = @Num_Proc_HEM and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HEM = @DC_HEM) 
			if @chkjob = 'S'  and @Grupo <>'ADMIN'
				Begin 
					Rollback Transaction 
					Return -31 
				End 



		End 

	Set @NF = IsNull((Select  Num_NF_HEM From  Cta_Cte_Hou_Exp_Mar Where Num_Proc_HEM = @Num_Proc_HEM and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_HEM = @DC_HEM ) , '') 
	If @NF <> '' and @NF <> '0'
		Begin 
			RollBack Transaction 
			Return -9 
		End 

	Set @Dt_Ins = (Select Convert(DateTime, Dt_Ins_HEM, 105) From Cta_Cte_Hou_Exp_Mar  Where Num_Proc_HEM = @Num_Proc_HEM and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_HEM = @DC_HEM )	
	If (@Dt_Ins <> Dbo.Hoje(GetDate()) and  @Grupo <> 'ADMIN' and Left(@Num_Proc_HEM, 5) <> 'EMJOB' )
		Begin 
			RollBack Transaction 
			Return -10
		End 

	If Exists(select * from item_fat as ifat join fatura fat on  fat.fatcod = ifat.fatcod where fatstatus = 1 and ifat.Num_proc = @Num_Proc_HEM and ifat.cd_tp_Tx = @Cd_Tp_Tx and ifat.dc = @DC_HEM )
		Begin 
			RollBack Transaction 
			Return -11
		End 

	Set @Vlr_Contab = IsNull((Select Val_Con_Comp from Cta_Cte_Hou_Exp_Mar Where  Num_Proc_HEM = @Num_Proc_HEM and Cd_Tp_Tx =@Cd_Tp_Tx and DC_HEM = @DC_HEM), 0)
--	If (@Vlr_Contab > 0  )
--		Begin 
--			RollBack Transaction 
--			Return -12
--		End 

	if @IntDefinitiva = 0 
		Set @Vlr_Contab =  null 


	If  Exists(Select Num_Proc_HEM from Cta_Cte_Hou_Exp_Mar Where  Num_Proc_HEM = @Num_Proc_HEM and Cd_Tp_Tx =@Cd_Tp_Tx and DC_HEM = @DC_HEM) 
		Begin 
			If Not Exists (Select  * From  Caixa_Hou_Exp_Mar Where Num_Proc_HEM = @Num_Proc_HEM and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_HEM = @DC_HEM ) 
				Begin 
					Delete From 
						Cta_Cte_Hou_Exp_Mar
					Where 
						Num_Proc_HEM = @Num_Proc_HEM and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_HEM = @DC_HEM
					If @@Error  =  0  	
						Begin 
							Exec pLogCtaCte_Ins  
								'E', @Num_Proc_HEM, @Cd_Tp_Tx,@DC_HEM, @Org_Ins_HEM,@Dt_Ins_HEM, @Cd_Tp_Moeda, 
								@Vlr_Org_HEM, @Dt_Prev_Pgto_HEM,@Cd_Cred_Dev_HEM, @Desp_Dst_HEM,@CPMF_HEM,@Comp_RP_HEM, 
								@Comp_DN_HEM, @Comp_CN_HEM, @Comp_CPA_HEM, @Usuario, @Vlr_Contab 
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
