SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCtaCteMIM_Ins    Script Date: 17/10/2002 07:32:48 ******/
CREATE PROCEDURE pCtaCteMIM_Ins 
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
@Desp_Org_MIM		char(1),
@CPMF_MIM			char(1), 
@Comp_RP_MIM		char(1), 
@Comp_DN_MIM		char(1),
@Comp_CN_MIM		char(1),
@Comp_CPA_MIM		char(1), 
@Num_DCN_MIM		varchar(12)=Null, 
@Dt_Ctb_CC_MIM		varchar(10)=Null,
@Usuario			Varchar(6),
@IntDefinitiva			int=null
)
--Parâmetros de Retorno 
--(1) Procedimento concluído com exito 
--(-1) Violação de Chave 
--(-2) Erro no Procedimento 
--(-3) Erro na Inserção do Log 
 AS
	Declare @Num_Proc_HIM 	VarChar(16) 
	Declare @Peso			Float
	Declare @StatusHouse		Integer 
	Declare @Rateio_Tx		Char(1) 
	Declare @Fator_Rateio		Float 
	Declare @ValorRateado		Float 
	Declare @Grupo		VarChar(30)
--	Set @Rateio_Tx = (Select Rateio_Tx From Tipo_Taxa Where Cd_Tp_Tx = @Cd_Tp_Tx) 
--	Declare CurHouses Cursor For 
--		Select 
--			Num_Proc_HIM, Peso_Liquido_HIM
--		From  
--			House_Imp_Mar 
--		Where 
--			Left(Num_Proc_HIM, 14) = @Num_Proc_MIM
	Begin Transaction  
	Set @Dt_Ins_MIM = (Select DBO.STRHOJE(GETDATE()) AS HOJE)
	Set @Grupo = IsNull((Select Grupo From Usuario Where Cd_Usuario = @Usuario),'')
	If  Not Exists(Select Num_Proc_MIM from Cta_Cte_Mas_Imp_Mar Where  Num_Proc_MIM = @Num_Proc_MIM and Cd_Tp_Tx =@Cd_Tp_Tx and DC_MIM = @DC_MIM) 
		Begin 

			If @DC_MIM = 'D' and @Cd_Tp_Tx in (Select Cd_Tp_Tx From Tipo_Taxa Where Pft_Aer = 'S') and @Grupo <>'ADMIN'
				Begin
					RollBack Transaction 
					Return - 33
				End 


			Insert into  
				Cta_Cte_Mas_Imp_Mar
				(Num_Proc_MIM,Cd_Tp_Tx,DC_MIM,Org_Ins_MIM,Dt_Ins_MIM,Cd_Tp_Moeda,Vlr_Org_MIM,Dt_Prev_Pgto_MIM, 
				Cd_Cred_Dev_MIM,Desp_Org_MIM,CPMF_MIM,Comp_RP_MIM, Comp_DN_MIM, Comp_CN_MIM, Comp_CPA_MIM)
			Values 	
				( @Num_Proc_MIM, @Cd_Tp_Tx,@DC_MIM, @Org_Ins_MIM,@Dt_Ins_MIM, @Cd_Tp_Moeda, @Vlr_Org_MIM, 
				@Dt_Prev_Pgto_MIM,@Cd_Cred_Dev_MIM, @Desp_Org_MIM,@CPMF_MIM,@Comp_RP_MIM, @Comp_DN_MIM, 
				@Comp_CN_MIM, @Comp_CPA_MIM)
			If @@RowCount  = 1  	
				Begin 
					Exec pLogCtaCte_Ins 
						'I', @Num_Proc_MIM, @Cd_Tp_Tx,@DC_MIM, @Org_Ins_MIM,@Dt_Ins_MIM, @Cd_Tp_Moeda, 
						@Vlr_Org_MIM, @Dt_Prev_Pgto_MIM,@Cd_Cred_Dev_MIM, @Desp_Org_MIM,@CPMF_MIM,@Comp_RP_MIM, 
						@Comp_DN_MIM, @Comp_CN_MIM, @Comp_CPA_MIM, @usuario 
					If @@RowCount = 1 
						Begin 
--							If @Rateio_Tx <> 'N'   and @DC_MIM = 'D'
--								Begin 
--									If @Rateio_Tx = 'H'  
--										Set @Fator_Rateio = (Select Count (*)  From House_Imp_Mar Where Left(Num_Proc_HIM, 14) =  @Num_Proc_MIM)
--									Else
--										Set @Fator_Rateio = (Select Sum (Peso_Liquido_HIM)  From House_Imp_Mar Where Left(Num_Proc_HIM, 14) =  @Num_Proc_MIM)
--									Open CurHouses 
--									Fetch Next From CurHouses Into @Num_Proc_HIM, @Peso 
--									While @@Fetch_Status = 0 
--									Begin 
--										If @Rateio_Tx = 'H' 
--											Set @ValorRateado = (1/@Fator_Rateio) * @Vlr_Org_MIM	
--										Else	
--											Set @ValorRateado = (@Peso/@Fator_Rateio) * @Vlr_Org_MIM	
--										Exec @StatusHouse = pCtaCteHIM_Ins @Num_Proc_HIM,  @Cd_Tp_Tx,@DC_MIM,
--												          'Rateio',@Dt_Ins_MIM,@Cd_Tp_Moeda,@ValorRateado,@Dt_Prev_Pgto_MIM,
--												          @Cd_Cred_Dev_MIM,@Desp_Org_MIM,@CPMF_MIM,'N', 'N','N','N',
---												          @Num_DCN_MIM,@Dt_Ctb_CC_MIM,@Usuario
--										If @StatusHouse <> 1 
--											Begin 
--												Print @StatusHouse 												
--												RollBack Transaction
--												Close CurHouses 
--												Deallocate CurHouses
--												Return @StatusHouse 
--											End 
--										Fetch Next From CurHouses Into @Num_Proc_HIM, @Peso 
--									End  
--								End 
							Commit Transaction
--							Deallocate CurHouses
							Return 1 
						End 
					Else
						Begin 
							RollBack Transaction 
--							Deallocate CurHouses
							Return -3
						End 
				End 
			Else
				Begin 
					Rollback Transaction 
---					Deallocate CurHouses
					Return - 2 
				End 
			
		End 
	Else
		Begin 
			Rollback Transaction 
--			Deallocate CurHouses
			Return - 1 
		End
GO
