SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pCtaCteHEA_Ins 
(
@Num_Proc_HEA		varchar(16), 
@Cd_Tp_Tx			varchar(3),
@DC_HEA			char(1),
@Org_Ins_HEA			varchar(9),
@Dt_Ins_HEA			varchar(10), 
@Cd_Tp_Moeda		varchar(3), 
@Vlr_Org_HEA			float, 
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
@Usuario			Varchar(6), 
@Comp_HAWB_HEA		char(1),
@Sys				bit = 0,
@IntDefinitiva			int=null
)
--Parâmetros de Retorno 
--(1) Procedimento concluído com exito 
--(-1) Violação de Chave 
--(-2) Erro no Procedimento 
--(-3) Erro na Inserção do Log 
 AS
	Begin Transaction  
	Declare @Cd_Cliente		varchar(10) 
	Declare @Cd_Area		varchar(3) 
	Declare @JOB 			Varchar(16) 
	Declare @chkjob		char(1) 
	Declare @Comp_Job_HEA	char(1)
	Declare @Grupo		VarChar(10) 



	Set @Cd_Cliente = IsNull((Select Cd_Export_HEA From House_Exp_Aer Where Num_Proc_HEA = @Num_Proc_HEA),  '')
	Set @Cd_Area = IsNull((Select Cd_Area From Usuario Where Cd_Usuario = @Usuario),'') 
	Set @JOB = IsNull((Select JOB_HEA From House_Exp_Aer Where Num_Proc_HEA = @Num_Proc_HEA),  '')
	Set @Grupo = (Select Grupo From Usuario Where Cd_Usuario = @Usuario)
	Set @Dt_Ins_HEA = (Select DBO.STRHOJE(GETDATE()) AS HOJE)
	If substring(@Num_Proc_HEA, 3,3) = 'JOB'
		Set @Comp_Job_HEA = 'S'
	Else
		Set @Comp_Job_HEA = 'N'
	

	If  Not Exists(Select Num_Proc_HEA from Cta_Cte_Hou_Exp_Aer Where  Num_Proc_HEA = @Num_Proc_HEA and Cd_Tp_Tx =@Cd_Tp_Tx and DC_HEA = @DC_HEA) 
		Begin 
	
			If @Job <> '' and @Num_Proc_HEA <> @JOB and @Sys = 0 
				Begin
					If @Cd_Tp_Tx not in (Select Cd_Tp_Tx From tipo_taxa_oper)
						begin 
							if (@Cd_Area <> 'CSR' and @Grupo <>'ADMIN') and  @Cd_Cred_Dev_HEA = @Cd_Cliente
								Begin 
									Rollback Transaction 
									Return -32
								End 
						end 
				End 


			Insert into  
				Cta_Cte_Hou_Exp_Aer
				(Num_Proc_HEA,Cd_Tp_Tx,DC_HEA,Org_Ins_HEA,Dt_Ins_HEA,Cd_Tp_Moeda,Vlr_Org_HEA,Dt_Prev_Pgto_HEA, 
				Cd_Cred_Dev_HEA,Desp_Dst_HEA,CPMF_HEA,Comp_RP_HEA, Comp_DN_HEA, Comp_CN_HEA, Comp_CPA_HEA, 
				Num_DCN_HEA,Dt_Ctb_CC_HEA, Comp_HAWB_HEA, Comp_Job_HEA)
			Values 	
				( @Num_Proc_HEA, @Cd_Tp_Tx,@DC_HEA, @Org_Ins_HEA,@Dt_Ins_HEA, @Cd_Tp_Moeda, @Vlr_Org_HEA, 
				@Dt_Prev_Pgto_HEA,@Cd_Cred_Dev_HEA, @Desp_Dst_HEA,@CPMF_HEA,@Comp_RP_HEA, @Comp_DN_HEA, 
				@Comp_CN_HEA, @Comp_CPA_HEA, @Num_DCN_HEA,@Dt_Ctb_CC_HEA, @Comp_HAWB_HEA, @Comp_Job_HEA )
			If @@RowCount  = 1  	
				Begin 
					Exec pLogCtaCte_Ins 
						'I', @Num_Proc_HEA, @Cd_Tp_Tx,@DC_HEA, @Org_Ins_HEA,@Dt_Ins_HEA, @Cd_Tp_Moeda, 
						@Vlr_Org_HEA, @Dt_Prev_Pgto_HEA,@Cd_Cred_Dev_HEA, @Desp_Dst_HEA,@CPMF_HEA,@Comp_RP_HEA, 
						@Comp_DN_HEA, @Comp_CN_HEA, @Comp_CPA_HEA, @usuario 
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
