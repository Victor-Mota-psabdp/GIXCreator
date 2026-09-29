SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pShipperInstM_Sel 
(
@Num_Proc 		VarChar(16) 
) 
AS
	Declare @Seq 		VarChar(8)
	Declare @Id		Int 
	Declare @Tipo		VarChar(3)
	Declare @StrDimensoes 	VarChar(300) 
	Declare @Dimensao 	VarChar(60)
	Declare @StrPO 	VarChar(300) 
	Declare @PO	 	VarChar(60)
	Declare @StrNCM	VarChar(80)
	Declare @StrVol		VarChar(300)
	Declare @NCM		VarChar(10)
	Declare @Vol		VarChar(300)
	Set @Id = Cast(Substring(@Seq, 4, 8) as Int) 
	Set @Tipo = Left(@Seq, 3) 


	Declare Cur_PO Cursor For 
	Select 
		Cast(Numero_PO_HIM as VarChar(30))+ '  ' + Convert(Varchar(30), Data_PO_HIM, 103) 
	From 
		PO_HIM
	Where
		Num_Proc_HIM = @Num_Proc 

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
		Cast(Qtd_Vol_IM as VarChar(8))+ ' VOL ' + Cast(Compr_IM as VarChar(8)) + 'X' + Cast(Largura_IM as VarChar(8)) + 'X' + Cast(Altura_IM as VarChar(8)) + ' ' + Cast(Cd_Tp_Unidade as VarChar(8))
	From 
		Volume_Imp_Mar
	Where
		Num_Proc_HIM = @Num_Proc 

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




	Declare Cur_NCM Cursor For 
	Select 
		Cast(NCM.NCM as VarChar(8)), TE.Nome_Tp_Embal
	From 
		Volume_Imp_Mar as VIM Left Outer Join NCM on NCM.Id_NCM = VIM.ID_NCM 
		Left Outer Join  Tipo_Embalagem as TE on TE.Cd_Tp_Embal = VIM.Cd_Tp_Embal
	Where
		Num_Proc_HIM = @Num_Proc 

	Open Cur_NCM
	Fetch Next From Cur_NCM Into @NCM, @Vol
	While @@FETCH_STATUS = 0
		Begin 
			If @StrNCM = ''  or @StrNCM = Null 
				Begin 
					Set @StrNCM = @NCM
				End 
			Else
				Begin 	
					Set @StrNCM = @StrNCM  + ' - ' + @NCM
				End 

			If @StrVol = ''  or @StrVol = Null 
				Begin 
					Set @StrVol = @Vol
				End 
			Else
				Begin 	
					Set @StrVol = @StrVol  + ' - ' + @Vol
				End 
			Fetch Next From Cur_NCM Into @NCM, @Vol
		End 
	Close Cur_NCM
	Deallocate Cur_NCM

	Select 
		HIM.*, @Po as PO, Shipper.Nome_Raz_Soc as Shipper, Consig.Nome_Raz_Soc as Consignatario, 
		EndConsig.*, Origem.Nome_Local as Origem, Destino.Nome_Local as Destino, @StrDimensoes as Dimensoes,
		@StrNCM as NCM, @StrVol as Volume, Com.Cd_Int as Codi_Intl, Com.Cd_Area_Fone as Cod_Aerea, Com.Prefixo as Prefixo, 
		Com.Num_Fone as Fone, Armador.Nome_Raz_Soc as Armador, Armador.Num_CPF_CNPJ as CNPJ_Consignee, 
		TP.Nome_Tp_Prod
	From 
		House_Imp_Mar as HIM 	Left Outer Join Pessoa as Shipper on HIM.Cd_Export_HIM = Shipper.Cd_Pes 
		Left Outer Join Pessoa as Consig on HIM.Cd_Consig_HIM = Consig.Cd_Pes 
		Left Outer Join Endereco as EndConsig on (EndConsig.Cd_Pes = HIM.Cd_Consig_HIM and Cd_Tp_End = 'COM')
		Left Outer Join Localidade as Origem on HIM.Cd_Org_HIM = Origem.Cd_Local 
		Left Outer Join Localidade as Destino on HIM.Cd_Dst_HIM = Destino.Cd_Local 
		Left Outer Join Comunicacao as Com on Com.Cd_Pes = HIM.Cd_Consig_HIM and Com.Cd_Tp_Com = 'TC1'
		Left Outer Join Job_Imp_Mar as JIM on JIM.Num_Proc_HIM = HIM.Num_Proc_HIM
		Left Outer Join Pessoa as Armador on Armador.Cd_Pes = JIM.Cd_Armador
		Left Outer Join Tipo_Produto as TP on HIM.Cd_Tp_Prod = TP.Cd_Tp_Prod 
	Where
		HIM.Num_Proc_HIM = @Num_Proc
GO
