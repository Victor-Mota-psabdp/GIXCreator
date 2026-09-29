SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE pCtaCteHIM_Upd
(
@Num_Proc_HIM		varchar(16), 
@Cd_Tp_Tx			varchar(3),
@DC_HIM			char(1),
@Org_Ins_HIM			varchar(9),
@Dt_Ins_HIM			varchar(10), 
@Cd_Tp_Moeda		varchar(3), 
@Vlr_Org_HIM			float, 
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
	Declare @Fatura	Varchar(16)

	Set @JOB = IsNull((Select JOB_HIM From House_Imp_Mar Where Num_Proc_HIM = @Num_Proc_HIM),  '')
	Set @Cd_Area = IsNull((Select Cd_Area From Usuario Where Cd_Usuario = @Usuario),'') 
	Set @Cd_Cliente = IsNull((Select Cd_Import_HIM From House_Imp_Mar Where Num_Proc_HIM = @Num_Proc_HIM),  '')
	Set @Grupo = (Select Grupo From Usuario Where Cd_Usuario = @Usuario)
	Set @Vlr_Contab = IsNull((Select  Val_Con_Comp From  Cta_Cte_Hou_Imp_Mar Where Num_Proc_HIM = @Num_Proc_HIM and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_HIM = @DC_HIM ) , 0) 
	Set @Fatura = IsNull((select top 1 itf.fatcod From item_fat itf join fatura fat on fat.fatcod = itf.fatcod where itf.Num_proc = @Num_Proc_HIM and  Itf.Cd_Tp_Tx =@Cd_Tp_Tx AND DC = @DC_HIM and FatStatus <>0 ), '')


	If @Job <> '' and @Num_Proc_HIM <> @JOB 
		Begin 
			Set @chkjob = (Select Comp_Job_HIM From Cta_Cte_Hou_Imp_Mar Where Num_Proc_HIM = @Num_Proc_HIM and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIM = @DC_HIM) 
			if @chkjob = 'S' and @Grupo <>'ADMIN'
				Begin 
					Rollback Transaction 
					Return -31 
				End 

			if (@Cd_Area <> 'CSR' and @Grupo <>'ADMIN') and  @Cd_Cred_Dev_HIM = @Cd_Cliente
				Begin 
					If @Cd_Tp_Tx not in (Select Cd_Tp_Tx From tipo_taxa_oper)
						begin 
							Rollback Transaction 
							Return -32
						end
				End 
		End 

	If @DC_HIM = 'D' and @Cd_Tp_Tx in (Select Cd_Tp_Tx From Tipo_Taxa Where Pft_Mar = 'S') and @Grupo <>'ADMIN'
		Begin
			RollBack Transaction 
			Return - 33
		End 


	Set @NF = IsNull((Select  Num_NF_HIM From  Cta_Cte_Hou_Imp_Mar Where Num_Proc_HIM = @Num_Proc_HIM and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_HIM = @DC_HIM ) , '') 
	If @NF <> ''  and @NF <> '0'
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

	If Not Exists (Select  * From  Caixa_Hou_Imp_Mar Where Num_Proc_HIM = @Num_Proc_HIM and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_HIM = @DC_HIM ) 
		Begin 
			Update 
				Cta_Cte_Hou_Imp_Mar
			Set 	
				Num_Proc_HIM = @Num_Proc_HIM,
				Cd_Tp_Tx = @Cd_Tp_Tx,
				DC_HIM=@DC_HIM,
				Org_Ins_HIM = @Org_Ins_HIM,
				--Dt_Ins_HIM=@Dt_Ins_HIM, 
				Cd_Tp_Moeda=@Cd_Tp_Moeda, 
				Vlr_Org_HIM=@Vlr_Org_HIM, 
				Dt_Prev_Pgto_HIM= @Dt_Prev_Pgto_HIM, 
				Cd_Cred_Dev_HIM=@Cd_Cred_Dev_HIM, 
				Desp_Org_HIM=@Desp_Org_HIM,
				CPMF_HIM=@CPMF_HIM,	
				Comp_RP_HIM=@Comp_RP_HIM, 
				Comp_DN_HIM=@Comp_DN_HIM, 
				Comp_CN_HIM=@Comp_CN_HIM, 
				Comp_CPA_HIM=@Comp_CPA_HIM, 
				Num_DCN_HIM=@Num_DCN_HIM,
				Dt_Ctb_CC_HIM=@Dt_Ctb_CC_HIM
			Where 
				Num_Proc_HIM = @Num_Proc_HIM and 
				Cd_Tp_Tx = @Cd_Tp_Tx and 
				DC_HIM = @DC_HIM
			If @@RowCount  = 1  	
				Begin 
					Exec pLogCtaCte_Ins
						'A', @Num_Proc_HIM, @Cd_Tp_Tx,@DC_HIM, @Org_Ins_HIM,@Dt_Ins_HIM, @Cd_Tp_Moeda, 
						@Vlr_Org_HIM, @Dt_Prev_Pgto_HIM,@Cd_Cred_Dev_HIM, @Desp_Org_HIM,@CPMF_HIM,@Comp_RP_HIM, 
						@Comp_DN_HIM, @Comp_CN_HIM, @Comp_CPA_HIM, @Usuario 
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
