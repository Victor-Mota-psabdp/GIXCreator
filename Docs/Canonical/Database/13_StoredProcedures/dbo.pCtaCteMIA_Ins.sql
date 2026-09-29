SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCtaCteMIA_Ins    Script Date: 17/10/2002 07:32:48 ******/
CREATE PROCEDURE pCtaCteMIA_Ins 
(
@Num_Proc_MIA		varchar(16), 
@Cd_Tp_Tx			varchar(3), 
@DC_MIA			char(1),
@Org_Ins_MIA			varchar(9),
@Dt_Ins_MIA			varchar(10), 
@Cd_Tp_Moeda		varchar(3), 
@Vlr_Org_MIA			Float, 
@Dt_Prev_Pgto_MIA		varchar(10), 
@Cd_Cred_Dev_MIA		varchar(10), 
@Desp_Org_MIA		char(1),
@CPMF_MIA			char(1), 
@Comp_RP_MIA		char(1), 
@Comp_DN_MIA		char(1),
@Comp_CN_MIA		char(1),
@Comp_CPA_MIA		char(1), 
@Num_DCN_MIA		varchar(12)=Null, 
@Dt_Ctb_CC_MIA		varchar(10)=Null,
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
--			Left(Num_Proc_HIM, 14) = @Num_Proc_MIA
	Begin Transaction  
	Set @Dt_Ins_MIA = (Select DBO.STRHOJE(GETDATE()) AS HOJE)
	Set @Grupo = IsNull((Select Grupo From Usuario Where Cd_Usuario = @Usuario),'')
	If  Not Exists(Select Num_Proc_MIA from Cta_Cte_Mas_Imp_Aer Where  Num_Proc_MIA = @Num_Proc_MIA and Cd_Tp_Tx =@Cd_Tp_Tx and DC_MIA = @DC_MIA) 
		Begin 

			If @DC_MIA = 'D' and @Cd_Tp_Tx in (Select Cd_Tp_Tx From Tipo_Taxa Where Pft_Aer = 'S') and @Grupo <>'ADMIN'
				Begin
					RollBack Transaction 
					Return - 33
				End 


			Insert into  
				Cta_Cte_Mas_Imp_Aer
				(Num_Proc_MIA,Cd_Tp_Tx,DC_MIA,Org_Ins_MIA,Dt_Ins_MIA,Cd_Tp_Moeda,Vlr_Org_MIA,Dt_Prev_Pgto_MIA, 
				Cd_Cred_Dev_MIA,Desp_Org_MIA,CPMF_MIA,Comp_RP_MIA, Comp_DN_MIA, Comp_CN_MIA, Comp_CPA_MIA)
			Values 	
				( @Num_Proc_MIA, @Cd_Tp_Tx,@DC_MIA, @Org_Ins_MIA,@Dt_Ins_MIA, @Cd_Tp_Moeda, @Vlr_Org_MIA, 
				@Dt_Prev_Pgto_MIA,@Cd_Cred_Dev_MIA, @Desp_Org_MIA,@CPMF_MIA,@Comp_RP_MIA, @Comp_DN_MIA, 
				@Comp_CN_MIA, @Comp_CPA_MIA)
			If @@RowCount  = 1  	
				Begin 
					Exec pLogCtaCte_Ins 
						'I', @Num_Proc_MIA, @Cd_Tp_Tx,@DC_MIA, @Org_Ins_MIA,@Dt_Ins_MIA, @Cd_Tp_Moeda, 
						@Vlr_Org_MIA, @Dt_Prev_Pgto_MIA,@Cd_Cred_Dev_MIA, @Desp_Org_MIA,@CPMF_MIA,@Comp_RP_MIA, 
						@Comp_DN_MIA, @Comp_CN_MIA, @Comp_CPA_MIA, @usuario 
					If @@RowCount = 1 
						Begin 
--							If @Rateio_Tx <> 'N'   and @DC_MIA = 'D'
--								Begin 
--									If @Rateio_Tx = 'H'  
--										Set @Fator_Rateio = (Select Count (*)  From House_Imp_Mar Where Left(Num_Proc_HIM, 14) =  @Num_Proc_MIA)
--									Else
--										Set @Fator_Rateio = (Select Sum (Peso_Liquido_HIM)  From House_Imp_Mar Where Left(Num_Proc_HIM, 14) =  @Num_Proc_MIA)
--									Open CurHouses 
--									Fetch Next From CurHouses Into @Num_Proc_HIM, @Peso 
--									While @@Fetch_Status = 0 
--									Begin 
--										If @Rateio_Tx = 'H' 
--											Set @ValorRateado = (1/@Fator_Rateio) * @Vlr_Org_MIA	
--										Else	
--											Set @ValorRateado = (@Peso/@Fator_Rateio) * @Vlr_Org_MIA	
--										Exec @StatusHouse = pCtaCteHIM_Ins @Num_Proc_HIM,  @Cd_Tp_Tx,@DC_MIA,
--												          'Rateio',@Dt_Ins_MIA,@Cd_Tp_Moeda,@ValorRateado,@Dt_Prev_Pgto_MIA,
--												          @Cd_Cred_Dev_MIA,@Desp_Org_MIA,@CPMF_MIA,'N', 'N','N','N',
---												          @Num_DCN_MIA,@Dt_Ctb_CC_MIA,@Usuario
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
