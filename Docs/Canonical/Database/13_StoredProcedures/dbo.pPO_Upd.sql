SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE pPO_Upd
(
@Num_Proc		VarChar(16), 
@PO			VarChar(30),
@Data			DateTime, 
@ID			Int, 
@Modal		VarChar(2)
)
AS
	If @Modal = 'IA'
		Begin 
			Update 
				PO_HIA
			Set 
				Numero_PO_HIA = @PO, Data_PO_HIA = @Data
			Where
				Num_Proc_HIA = @Num_Proc and 
				ID_PO_HIA = @ID
			Return @@RowCount
		End
	If @Modal = 'EA'
		Begin 
			Update 
				PO_HEA
			Set 
				Numero_PO_HEA = @PO, Data_PO_HEA = @Data
			Where
				Num_Proc_HEA = @Num_Proc and 
				ID_PO_HEA = @ID
			Return @@RowCount
		End
	If @Modal = 'IM'
		Begin 
			Update 
				PO_HIM
			Set 
				Numero_PO_HIM = @PO, Data_PO_HIM = @Data
			Where
				Num_Proc_HIM = @Num_Proc and 
				ID_PO_HIM = @ID
			Return @@RowCount
		End
	If @Modal = 'EM'
		Begin 
			Update 
				PO_HEM
			Set 
				Numero_PO_HEM = @PO, Data_PO_HEM = @Data
			Where
				Num_Proc_HEM = @Num_Proc and 
				ID_PO_HEM = @ID
			Return @@RowCount
		End

GO
