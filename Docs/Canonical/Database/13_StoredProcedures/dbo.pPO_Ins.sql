SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE pPO_Ins  
(
@Num_Proc		VarChar(16), 
@PO			VarChar(30),
@Data			DateTime = Null ,
@Modal 		VarChar(2) 
)
AS
	Declare @Max 	Int 
	If @Modal = 'IA'
		Begin 
			Set @Max = IsNull((Select Max(ID_PO_HIA) From PO_HIA),0) +1
			Insert Into 
				PO_HIA (Num_Proc_HIA, ID_PO_HIA, Numero_PO_HIA, Data_PO_HIA)
			Values 
				(@Num_Proc, @Max, @PO, @Data) 
			Return @@RowCount
		End
	If @Modal = 'IM'
		Begin 
			Set @Max = IsNull((Select Max(ID_PO_HIM) From PO_HIM),0) +1
			Insert Into 
				PO_HIM (Num_Proc_HIM, ID_PO_HIM, Numero_PO_HIM, Data_PO_HIM)
			Values 
				(@Num_Proc, @Max, @PO, @Data) 
			Return @@RowCount
		End
	If @Modal = 'EA'
		Begin 
			Set @Max = IsNull((Select Max(ID_PO_HEA) From PO_HEA),0) +1
			Insert Into 
				PO_HEA (Num_Proc_HEA, ID_PO_HEA, Numero_PO_HEA, Data_PO_HEA)
			Values 
				(@Num_Proc, @Max, @PO, @Data) 
			Return @@RowCount
		End
	If @Modal = 'EM'
		Begin 
			Set @Max = IsNull((Select Max(ID_PO_HEM) From PO_HEM),0) +1
			Insert Into 
				PO_HEM (Num_Proc_HEM, ID_PO_HEM, Numero_PO_HEM, Data_PO_HEM)
			Values 
				(@Num_Proc, @Max, @PO, @Data) 
			Return @@RowCount
		End
GO
