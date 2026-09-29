SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pShipperInstA_Sel 
(
@Num_Proc 		VarChar(16) 
) 
AS
	Declare @Seq 		VarChar(8)
	Declare @Id		Int 
	Declare @Tipo		VarChar(3)
	Declare @StrDimensoes 	VarChar(256) 
	Declare @Dimensao 	VarChar(60)
	Declare @StrPO 	VarChar(256) 
	Declare @PO	 	VarChar(60)
	Set @Id = Cast(Substring(@Seq, 4, 8) as Int) 
	Set @Tipo = Left(@Seq, 3) 


	Declare Cur_PO Cursor For 
	Select 
		Cast(Numero_PO_HIA as VarChar(30))+ '  ' + Convert(Varchar(30), Data_PO_HIA, 103) 
	From 
		PO_HIA
	Where
		Num_Proc_HIA = @Num_Proc 

	Open Cur_PO
	Fetch Next From Cur_PO Into @PO
	While @@FETCH_STATUS = 0
			Begin 
			If @StrPO = ''  or @StrPO = Null 
				Begin 
					Set @StrPO = @PO 
				End 
			Else
				Begin 	
					Set @StrPO = @StrPO  + ' - ' + @PO
				End 
			Fetch Next From Cur_PO Into @PO 					
		End 
	Close Cur_PO
	Deallocate Cur_PO

	Declare Cur_Dimensoes Cursor For 
	Select 
		Cast(Qtd_Vol_IA as VarChar(8))+ ' VOL ' + Cast(Compr_IA as VarChar(8)) + 'X' + Cast(Largura_IA as VarChar(8)) + 'X' + Cast(Altura_IA as VarChar(8)) + ' ' + Cast(Cd_Tp_Unidade as VarChar(8))
	From 
		Volume_Imp_Aer
	Where
		Num_Proc_HIA = @Num_Proc 

	Open Cur_Dimensoes 
	Fetch Next From Cur_Dimensoes Into @Dimensao 
	While @@FETCH_STATUS = 0
			Begin 
			If @StrDimensoes = ''  or @StrDimensoes = Null 
				Begin 
					Set @StrDimensoes = @Dimensao 
				End 
			Else
				Begin 	
					Set @StrDimensoes = @StrDimensoes  + '/' + @Dimensao
				End 
			Fetch Next From Cur_Dimensoes Into @Dimensao 					
		End 
	Close Cur_Dimensoes 
	Deallocate Cur_Dimensoes 


	Select 
		HIA.*, JIA.*, @Po as PO, Shipper.Nome_Raz_Soc as Shipper, Consig.Nome_Raz_Soc as Consignatario, 
		EndConsig.*, Origem.Nome_Local as Origem, Destino.Nome_Local as Destino, Cia.Nome_Cia_Aer as Nome_Cia_Aerea, Cast(@StrDimensoes as Varchar(256)) as 'Dimensoes',
		booDimensoes = 
		Case 
			When @StrDimensoes = '' or @StrDimensoes = Null then 0 
			Else 1 
		End, 
		Nome_Tp_Prod
	From 
		House_Imp_Aer as HIA Left Outer Join Job_Imp_Aer as JIA on HIA.Num_Proc_HIA = JIA.Num_Proc_HIA
		Left Outer Join Pessoa as Shipper on HIA.Cd_Export_HIA = Shipper.Cd_Pes 
		Left Outer Join Pessoa as Consig on HIA.Cd_Consig_HIA = Consig.Cd_Pes 
		Left Outer Join Endereco as EndConsig on (EndConsig.Cd_Pes = HIA.Cd_Consig_HIA and Cd_Tp_End = 'COM')
		Left Outer Join Localidade as Origem on HIA.Cd_Org_HIA = Origem.Cd_Local 
		Left Outer Join Localidade as Destino on HIA.Cd_Dst_HIA = Destino.Cd_Local 
		Left Outer Join Cia_Aerea as Cia on JIA.Cd_Cia_Aer = Cia.Cd_Cia_Aer 
		Left Outer Join Tipo_Produto as TP on HIA.Cd_Tp_Prod = TP.Cd_Tp_Prod 
	Where
		HIA.Num_Proc_HIA = @Num_Proc
GO
