SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCtaCteMEM_Ins    Script Date: 17/10/2002 07:32:48 ******/
CREATE PROCEDURE pCtaCteMEM_Ins 
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
@Usuario			Varchar(6),
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
--			Left(Num_Proc_HEM, 14) = @Num_Proc_MEM
	Begin Transaction 
	Set @Dt_Ins_MEM = (Select DBO.STRHOJE(GETDATE()) AS HOJE)
	If  Not Exists(Select Num_Proc_MEM from Cta_Cte_Mas_Exp_Mar Where  Num_Proc_MEM = @Num_Proc_MEM and Cd_Tp_Tx =@Cd_Tp_Tx and DC_MEM = @DC_MEM) 
		Begin 
			Insert into  
				Cta_Cte_Mas_Exp_Mar
				(Num_Proc_MEM,Cd_Tp_Tx,DC_MEM,Org_Ins_MEM,Dt_Ins_MEM,Cd_Tp_Moeda,Vlr_Org_MEM,Dt_Prev_Pgto_MEM, 
				Cd_Cred_Dev_MEM,Desp_Dst_MEM,CPMF_MEM,Comp_RP_MEM, Comp_DN_MEM, Comp_CN_MEM, Comp_CPA_MEM)
			Values 	
				( @Num_Proc_MEM, @Cd_Tp_Tx,@DC_MEM, @Org_Ins_MEM,@Dt_Ins_MEM, @Cd_Tp_Moeda, @Vlr_Org_MEM, 
				@Dt_Prev_Pgto_MEM,@Cd_Cred_Dev_MEM, @Desp_Dst_MEM,@CPMF_MEM,@Comp_RP_MEM, @Comp_DN_MEM, 
				@Comp_CN_MEM, @Comp_CPA_MEM)
			If @@RowCount  = 1  	
				Begin 
					Exec pLogCtaCte_Ins 
						'I', @Num_Proc_MEM, @Cd_Tp_Tx,@DC_MEM, @Org_Ins_MEM,@Dt_Ins_MEM, @Cd_Tp_Moeda, 
						@Vlr_Org_MEM, @Dt_Prev_Pgto_MEM,@Cd_Cred_Dev_MEM, @Desp_Dst_MEM,@CPMF_MEM,@Comp_RP_MEM, 
						@Comp_DN_MEM, @Comp_CN_MEM, @Comp_CPA_MEM, @usuario 
					If @@RowCount = 1 
						Begin 
--							If @Rateio_Tx <> 'N'   and @DC_MEM = 'D'
--								Begin 
--									If @Rateio_Tx = 'H'  
--										Set @Fator_Rateio = (Select Count (*)  From House_Exp_Mar WHERE Left(Num_Proc_HEM, 14) =  @Num_Proc_MEM)
--									Else
--										Set @Fator_Rateio = (Select Sum (Peso_Liquido_HEM)  From House_Exp_Mar WHERE Left(Num_Proc_HEM, 14) =  @Num_Proc_MEM)
--
--									Open CurHouses 
--									Fetch Next From CurHouses Into @Num_Proc_HEM, @Peso 
--									While @@Fetch_Status = 0 
--									Begin 
--										Print @Num_Proc_HEM
--										If @Rateio_Tx = 'H' 
--											Set @ValorRateado = (1/@Fator_Rateio) * @Vlr_Org_MEM	
--										Else	
--											Set @ValorRateado = (@Peso/@Fator_Rateio) * @Vlr_Org_MEM	
--										Exec @StatusHouse = pCtaCteHEM_Ins @Num_Proc_HEM,  @Cd_Tp_Tx,@DC_MEM,
--												          'Rateio',@Dt_Ins_MEM,@Cd_Tp_Moeda,@ValorRateado,@Dt_Prev_Pgto_MEM,
--												          @Cd_Cred_Dev_MEM,@Desp_Dst_MEM,@CPMF_MEM,'N', 'N','N','N',
--												          @Num_DCN_MEM,@Dt_Ctb_CC_MEM,@Usuario
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
