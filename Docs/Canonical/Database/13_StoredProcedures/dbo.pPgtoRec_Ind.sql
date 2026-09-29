SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pPgtoRec_Ind    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pPgtoRec_Ind 
(
@Num_Lcto		VarChar(12)='',
@Tipo_Move		Char(1), 	--Tipo de Movimento: (F) Move First / (P) Move Previous / (N) Move Next / (L) Move Last 
@Retorno		VarChar(12) = '' 	OUTPUT 
)
 AS
	If @Tipo_Move = 'F'
		Begin 
			Declare Cur_Indice Cursor Keyset For 
				Select Num_Lcto From Pgto_Rcto Order by Num_Lcto 
			
			Open Cur_Indice
				Fetch First From Cur_Indice Into @Retorno
			Close Cur_Indice 
			Deallocate Cur_Indice 
		End 	
	If @Tipo_move = 'P'
		Begin 
			Declare @Anterior	Varchar(12)
			Declare Cur_Indice Cursor Forward_Only For 
			Select Num_Lcto From Pgto_Rcto Where Num_Lcto = @Num_Lcto  Order by Num_Lcto 
			Open Cur_Indice
			Fetch Next From Cur_Indice Into  @Retorno 
			While @@Fetch_Status = 0
				Begin 
					If @Retorno   <> @Num_Lcto
						Set @Anterior = @Retorno
					Else
						Begin 
							Set @Retorno = @Anterior 
							Close Cur_Indice 
							Deallocate Cur_Indice 
							Return 
						End 
					Fetch Next From Cur_Indice Into  @Retorno 
				End 
		End 
	If @Tipo_Move = 'N'
		Begin 
			Declare Cur_Indice Cursor Forward_Only For 
				Select Num_Lcto From Pgto_Rcto Order by Num_Lcto 
			Open Cur_Indice
			Fetch Next From Cur_Indice Into  @Retorno 
			While @@Fetch_Status = 0
				Begin 
					If @Retorno   = @Num_Lcto
						Begin 
							Fetch Next From Cur_Indice Into  @Retorno 
							Close Cur_Indice 
							Deallocate Cur_Indice 
							Return 
						End 
					Fetch Next From Cur_Indice Into  @Retorno 
				End 
		End 
			
	If @Tipo_Move = 'L'
		Begin 
			Declare Cur_Indice Cursor Keyset For 
				Select Num_Lcto From Pgto_Rcto Order by Num_Lcto 
			
			Open Cur_Indice
				Fetch Last From Cur_Indice Into @Retorno
			Close Cur_Indice 
			Deallocate Cur_Indice 
		End



GO
