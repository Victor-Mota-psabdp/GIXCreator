SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pCtaCteHIM_Ins 
(
@Num_Proc_HIM		varchar(16), 
@Cd_Tp_Tx			varchar(3),
@DC_HIM			char(1),
@Org_Ins_HIM			varchar(9),
@Dt_Ins_HIM			varchar(10), 
@Cd_Tp_Moeda		varchar(3), 
@Vlr_Org_HIM			float, 
@Dt_Prev_Pgto_HIM		varchar(10)='', 
@Cd_Cred_Dev_HIM		varchar(10), 
@Desp_Org_HIM		char(1)='N',
@CPMF_HIM			char(1)='N', 
@Comp_RP_HIM		char(1)='N', 
@Comp_DN_HIM		char(1)='N',
@Comp_CN_HIM		char(1)='N',
@Comp_CPA_HIM		char(1)='N', 
@Num_DCN_HIM		varchar(12)=Null, 
@Dt_Ctb_CC_HIM		varchar(10)=Null,
@Usuario			Varchar(6), 
@Sys				bit = 0 ,
@IntDefinitiva			int=null

)
--Parâmetros de Retorno 
--(1) Procedimento concluído com exito 
--(-1) Violação de Chave 
--(-2) Erro no Procedimento 
--(-3) Erro na Inserção do Log 
 AS
	Begin Transaction  
	Declare @Cd_Cliente	varchar(10) 
	Declare @Cd_Area	varchar(3) 
	Declare @JOB 		Varchar(16) 
	Declare @chkjob	char(1) 
	Declare @Comp_Job_HIM	char(1)
	Declare @Grupo	varchar(10) 

	Set @Grupo = IsNull((Select Grupo From Usuario Where Cd_Usuario = @Usuario),'')
	--If @Cd_Tp_Tx = 'FRT'
	--	Set @CPMF_HIM = 'S'
	If  Not Exists(Select Num_Proc_HIM from Cta_Cte_Hou_iMP_Mar Where  Num_Proc_HIM = @Num_Proc_HIM and Cd_Tp_Tx =@Cd_Tp_Tx and DC_HIM = @DC_HIM) 
		Begin 
			Set @Cd_Cliente = IsNull((Select Cd_Import_HIM From House_Imp_Mar Where Num_Proc_HIM = @Num_Proc_HIM),  '')
			Set @Cd_Area = IsNull((Select Cd_Area From Usuario Where Cd_Usuario = @Usuario),'') 
			Set @JOB = IsNull((Select JOB_HIM From House_Imp_Mar Where Num_Proc_HIM = @Num_Proc_HIM),  '')
			Set @Dt_Ins_HIM = (Select DBO.STRHOJE(GETDATE()) AS HOJE)
			If substring(@Num_Proc_HIM, 3,3) = 'JOB'
				Set @Comp_Job_HIM = 'S'
			Else
				Set @Comp_Job_HIM = 'N'


			If @Job <> '' and @Num_Proc_HIM <> @JOB and @Sys = 0
				Begin
					If @Cd_Tp_Tx not in (Select Cd_Tp_Tx From tipo_taxa_oper)
						begin 
							if (@Cd_Area <> 'CSR' and @Grupo <>'ADMIN') and  @Cd_Cred_Dev_HIM = @Cd_Cliente
								Begin 
									Rollback Transaction 
									Return -32
								End 
						End
				End 

			If @DC_HIM = 'D' and @Cd_Tp_Tx in (Select Cd_Tp_Tx From Tipo_Taxa Where Pft_Mar = 'S') and @Grupo <>'ADMIN'
				Begin
					RollBack Transaction 
					Return - 33
				End 


			Insert into  
				Cta_Cte_Hou_Imp_Mar
				(Num_Proc_HIM,Cd_Tp_Tx,DC_HIM,Org_Ins_HIM,Dt_Ins_HIM,Cd_Tp_Moeda,Vlr_Org_HIM,Dt_Prev_Pgto_HIM, 
				Cd_Cred_Dev_HIM,Desp_Org_HIM,CPMF_HIM,Comp_RP_HIM, Comp_DN_HIM, Comp_CN_HIM, Comp_CPA_HIM, 
				Num_DCN_HIM,Dt_Ctb_CC_HIM, Comp_Job_HIM)
			Values 	
				( @Num_Proc_HIM, @Cd_Tp_Tx,@DC_HIM, @Org_Ins_HIM,@Dt_Ins_HIM, @Cd_Tp_Moeda, @Vlr_Org_HIM, 
				@Dt_Prev_Pgto_HIM,@Cd_Cred_Dev_HIM, @Desp_Org_HIM,@CPMF_HIM,@Comp_RP_HIM, @Comp_DN_HIM, 
				@Comp_CN_HIM, @Comp_CPA_HIM, @Num_DCN_HIM,@Dt_Ctb_CC_HIM, @Comp_Job_HIM)
			If @@RowCount  = 1  	
				Begin 
					Exec pLogCtaCte_Ins 
						'I', @Num_Proc_HIM, @Cd_Tp_Tx,@DC_HIM, @Org_Ins_HIM,@Dt_Ins_HIM, @Cd_Tp_Moeda, 
						@Vlr_Org_HIM, @Dt_Prev_Pgto_HIM,@Cd_Cred_Dev_HIM, @Desp_Org_HIM,@CPMF_HIM,@Comp_RP_HIM, 
						@Comp_DN_HIM, @Comp_CN_HIM, @Comp_CPA_HIM, @usuario 
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
			Return - 1 
		End
GO
