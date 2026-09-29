SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pCtaCteMEA_Ins 
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
@Usuario			Varchar(6), 
@Comp_MBL_MEA		char(1)='N',
@IntDefinitiva			int=null

)
--Parâmetros de Retorno 
--(1) Procedimento concluído com exito 
--(-1) Violação de Chave 
--(-2) Erro no Procedimento 
--(-3) Erro na Inserção do Log 
 AS
	Declare @Num_Proc_HEM 	VarChar(16) 
	Declare @Peso			Float
	Declare @StatusHouse		Integer 
	Declare @Rateio_Tx		Char(1) 
	Declare @Fator_Rateio		Float 
	Declare @ValorRateado		Float 


--	Set @Rateio_Tx = (Select Rateio_Tx From Tipo_Taxa Where Cd_Tp_Tx = @Cd_Tp_Tx) 
--	Declare CurHouses Cursor For 
--		Select 
--			Num_Proc_HEM, Peso_Liquido_HEM
--		From  
--			House_Exp_Mar 
--		Where 
--			Left(Num_Proc_HEM, 14) = @Num_Proc_MEA
	Begin Transaction 
	Set @Dt_Ins_MEA = (Select DBO.STRHOJE(GETDATE()) AS HOJE)



	If  Not Exists(Select Num_Proc_MEA from Cta_Cte_Mas_Exp_Aer Where  Num_Proc_MEA = @Num_Proc_MEA and Cd_Tp_Tx =@Cd_Tp_Tx and DC_MEA = @DC_MEA) 
		Begin 
			Insert into  
				Cta_Cte_Mas_Exp_Aer
				(Num_Proc_MEA,Cd_Tp_Tx,DC_MEA,Org_Ins_MEA,Dt_Ins_MEA,Cd_Tp_Moeda,Vlr_Org_MEA,Dt_Prev_Pgto_MEA, 
				Cd_Cred_Dev_MEA,Desp_Dst_MEA,CPMF_MEA,Comp_RP_MEA, Comp_DN_MEA, Comp_CN_MEA, Comp_CPA_MEA, Comp_MBL_MEA)
			Values 	
				( @Num_Proc_MEA, @Cd_Tp_Tx,@DC_MEA, @Org_Ins_MEA,@Dt_Ins_MEA, @Cd_Tp_Moeda, @Vlr_Org_MEA, 
				@Dt_Prev_Pgto_MEA,@Cd_Cred_Dev_MEA, @Desp_Dst_MEA,@CPMF_MEA,@Comp_RP_MEA, @Comp_DN_MEA, 
				@Comp_CN_MEA, @Comp_CPA_MEA, @Comp_MBL_MEA)
			If @@RowCount  = 1  	
				Begin 
					Exec pLogCtaCte_Ins 
						'I', @Num_Proc_MEA, @Cd_Tp_Tx,@DC_MEA, @Org_Ins_MEA,@Dt_Ins_MEA, @Cd_Tp_Moeda, 
						@Vlr_Org_MEA, @Dt_Prev_Pgto_MEA,@Cd_Cred_Dev_MEA, @Desp_Dst_MEA,@CPMF_MEA,@Comp_RP_MEA, 
						@Comp_DN_MEA, @Comp_CN_MEA, @Comp_CPA_MEA, @usuario
					If @@RowCount = 1 
						Begin 
--							If @Rateio_Tx <> 'N'   and @DC_MEA = 'D'
--								Begin 
--									If @Rateio_Tx = 'H'  
--										Set @Fator_Rateio = (Select Count (*)  From House_Exp_Mar WHERE Left(Num_Proc_HEM, 14) =  @Num_Proc_MEA)
--									Else
--										Set @Fator_Rateio = (Select Sum (Peso_Liquido_HEM)  From House_Exp_Mar WHERE Left(Num_Proc_HEM, 14) =  @Num_Proc_MEA)
--
--									Open CurHouses 
--									Fetch Next From CurHouses Into @Num_Proc_HEM, @Peso 
--									While @@Fetch_Status = 0 
--									Begin 
--										Print @Num_Proc_HEM
--										If @Rateio_Tx = 'H' 
--											Set @ValorRateado = (1/@Fator_Rateio) * @Vlr_Org_MEA	
--										Else	
--											Set @ValorRateado = (@Peso/@Fator_Rateio) * @Vlr_Org_MEA	
--										Exec @StatusHouse = pCtaCteHEM_Ins @Num_Proc_HEM,  @Cd_Tp_Tx,@DC_MEA,
--												          'Rateio',@Dt_Ins_MEA,@Cd_Tp_Moeda,@ValorRateado,@Dt_Prev_Pgto_MEA,
--												          @Cd_Cred_Dev_MEA,@Desp_Dst_MEA,@CPMF_MEA,'N', 'N','N','N',
--												          @Num_DCN_MEA,@Dt_Ctb_CC_MEA,@Usuario
--										If @StatusHouse <> 1 
--											Begin 
--												Close CurHouses 
--												Deallocate CurHouses
--												RollBack Transaction
--												Return @StatusHouse 
--											End 
--										Fetch Next From CurHouses Into @Num_Proc_HEM, @Peso 
--									End  
--								End 
--							Deallocate CurHouses
							Commit Transaction 
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
					RollBack Transaction 
--					Deallocate CurHouses
					Return - 2 
				End 
			
		End 
	Else
		Begin 
			RollBack Transaction 
--			Deallocate CurHouses
			Return - 1 
		End
GO
