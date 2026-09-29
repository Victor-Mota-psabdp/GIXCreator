SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE pProsoftAjuste_Upd
(
@IDMachine		VarChar(30)
)
AS
	Declare @Documento	Varchar(30)
	Declare @DocCompl	Varchar(30)
	Declare @Vlr_C		Decimal(12,2)
	Declare @Vlr_D		Decimal(12,2)
	Declare @Dif		Decimal(12,2) 
	Declare @Rest_Dif	Decimal(12,2) 
	Declare @Qtd_Itens	Int 
	Declare @Item		Int 
	Declare @Fator		Decimal(12,2)

	Update
		Tmp_Prosoft 
	Set 
		DC_Tax = 'D',
		Vlr_Lcto = abs(Vlr_Lcto )
	Where
		DC_Tax = 'C' and 
		Vlr_Lcto < 0  and 
		IDMachine = @IDMachine

	Update
		Tmp_Prosoft 
	Set 
		DC_Tax = 'C',
		Vlr_Lcto = abs(Vlr_Lcto )	
	Where
		DC_Tax = 'D' and 
		Vlr_Lcto < 0  and 
		IDMachine = @IDMachine

	Update 
		tmp_prosoft 
	Set 
		ccusto = '' 
	From 
		Tmp_Prosoft as TP Join Cta_Ctb as CC on CC.Cd_Cta_Ctb_Red = TP.Cta_Ctb and CC.Ck_Ativo = 'S' and CC.Ck_CC = 'N'
	Where 
		TP.CCusto <> ''




		


	Declare CurRemessa Cursor For 
		Select Distinct Num_Doc From Tmp_Prosoft Where IDMachine = @IDMachine and Left(Num_Doc, 2) in ('RA', 'RM')

	Open CurRemessa 
	Fetch Next From CurRemessa  into @Documento 
	While @@Fetch_Status = 0 
		Begin 
			Set @Vlr_C = IsNull((Select Sum(Vlr_Lcto) From Tmp_Prosoft Where IDMachine = @IDMachine and Num_Doc = @Documento and DC_Tax = 'C'  ),0)
			Set @Vlr_D = IsNull((Select Sum(Vlr_Lcto) From Tmp_Prosoft Where IDMachine = @IDMachine and Num_Doc = @Documento and DC_Tax = 'D'  ),0)
			If @Vlr_C <> @Vlr_D and (abs(@Vlr_C - @Vlr_D) <= 0.20)
				Begin 
					Set @Dif = @Vlr_C - @Vlr_D 
					If @Dif > 0 
						Begin 
							Declare CurItens  Cursor For 
							Select Num_Doc_Compl From Tmp_Prosoft Where IDMachine = @IDMachine and Num_Doc = @Documento and DC_Tax = 'D'
							Open CurItens 
							Fetch Next From CurItens into @DocCompl
							Set @Qtd_Itens = IsNull((Select Count(*) From Tmp_Prosoft Where IDMachine = @IDMachine and Num_Doc = @Documento and DC_Tax = 'D'),0)
							Set @Item = 1
							Set @Fator = (@Vlr_C - @Vlr_D) / @Qtd_Itens
							Set @Rest_Dif = (@Vlr_C - @Vlr_D)
							If @Fator = 0 
								Set @Fator = 0.01 
							Print @Item
							Print @Qtd_Itens
							Print '------------------'
							While @@Fetch_Status = 0 and @Item <= @Qtd_Itens
								Begin 
	

									If @Rest_Dif <= @Fator or @Item = @Qtd_Itens
										Begin 
											Set @Fator = @Rest_Dif
											Set @Rest_Dif =0 
											Set @Item = @Qtd_Itens + 1 
										End 
									Else 
										Begin 
											Set @Rest_Dif = @Rest_Dif - @Fator 
										End 

									Update 
										Tmp_Prosoft 
									Set 
										Vlr_Lcto = Vlr_Lcto + @Fator
									Where
										Num_Doc_Compl = @DocCompl and
										Num_Doc = @Documento 

									Set @Item = @Item + 1 

									Fetch Next From CurItens into @DocCompl

								End 
							Close CurItens
							Deallocate CurItens 
						End 

					If @Dif < 0 
						Begin 
							Declare CurItens  Cursor For 
							Select Num_Doc_Compl From Tmp_Prosoft Where IDMachine = @IDMachine and Num_Doc = @Documento and DC_Tax = 'D'
							Open CurItens 
							Fetch Next From CurItens into @DocCompl
							Set @Qtd_Itens = IsNull((Select Count(*) From Tmp_Prosoft Where IDMachine = @IDMachine and Num_Doc = @Documento and DC_Tax = 'D'),0)
							Set @Item = 1
							Set @Fator = (@Vlr_D - @Vlr_C) / @Qtd_Itens
							Set @Rest_Dif = (@Vlr_D - @Vlr_C)
							If @Fator = 0 
								Set @Fator = 0.01 
							Print @Item
							Print @Qtd_Itens
							Print '------------------'
							While @@Fetch_Status = 0 and @Item <= @Qtd_Itens
								Begin 
	

									If @Rest_Dif <= @Fator or @Item = @Qtd_Itens
										Begin 
											Set @Fator = @Rest_Dif
											Set @Rest_Dif =0 
											Set @Item = @Qtd_Itens + 1 
										End 
									Else 
										Begin 
											Set @Rest_Dif = @Rest_Dif - @Fator 
										End 

									Update 
										Tmp_Prosoft 
									Set 
										Vlr_Lcto = Vlr_Lcto - @Fator
									Where
										Num_Doc_Compl = @DocCompl and
										Num_Doc = @Documento 

									Set @Item = @Item + 1 

									Fetch Next From CurItens into @DocCompl

								End 
							Close CurItens
							Deallocate CurItens 
						End 


				End 
			Fetch Next From CurRemessa  into @Documento 
		End 
		Close CurRemessa 
		Deallocate CurRemessa


		Insert Into  Tmp_Prosoft 
		Select  
			IDMachine, Num_Doc,  '', Dt_Doc, DC_Doc, DC_Tax, 
			Cta_Ctb,  sUM(Vlr_Lcto), CCusto, left(historico, 15) + substring(historico, 33, len(historico))
		From 
			Tmp_prosoft 
		Where 
			IDMachine = @IDMachine and LEFT(Num_Doc, 2) IN ('LA','LB','LC')  and 
			Num_Doc_Compl LIKE 'PROV'
		Group by   
			IDMachine, Num_Doc, Dt_Doc, DC_Doc, DC_Tax, 
			Cta_Ctb, CCusto, left(historico, 15) + substring(historico, 33, len(historico))  
			
				

		Delete  
			Tmp_Prosoft 
		Where 
			IDMachine = @IDMachine and left(Num_Doc, 2) in ('LA','LB','LC')  and 
			Num_Doc_Compl like 'PROV'

GO
