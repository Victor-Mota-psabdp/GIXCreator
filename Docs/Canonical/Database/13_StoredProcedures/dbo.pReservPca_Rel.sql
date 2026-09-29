SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE  PROCEDURE pReservPca_Rel
(
@Num_Proc		VarChar(16)
)
 AS
	Declare @StrPO		VarChar(200)
	Declare @PO 		Varchar(200)
	Declare @StrVol		VarChar(400) 
	Declare @Vol		VarChar(400) 
	Declare @Navio		Varchar(50)
	Declare @Dt_Transb	Datetime 
	Declare @Transbordo	VarChar(500) 

	
	Declare Cur_Volume Cursor For 
	Select 
		Cast(Qtd_Vol_EM as VarChar(20)) +  '  ' + TE.Nome_Tp_Embal 
	From 
		Volume_Exp_Mar as VEM Join Tipo_Embalagem as TE on VEM.Cd_Tp_Embal = TE.Cd_Tp_Embal
	Where
		VEM.Num_Proc_HEM = @Num_Proc

	Open Cur_Volume
	
	Fetch Next From Cur_Volume Into @Vol
	While @@FETCH_STATUS = 0
			Begin 
			If @StrVol = ''  or @StrVol = Null 
				Begin 
					Set @StrVol = @Vol
				End 
			Else
				Begin 	
					Set @StrVol = @StrVol  + '/' + @Vol
				End 
			Fetch Next From Cur_Volume Into @Vol
		End 
	Close Cur_Volume
	Deallocate Cur_Volume 

	Declare Cur_PO Cursor For 
	Select 
		Cast(Numero_PO_HEM as VarChar(30))
	From 
		PO_HEM
	Where
		Num_Proc_HEM = @Num_Proc 

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

	Declare CurTransb Cursor For 
	Select 
		Navio_HEM as Navio, Dt_Transb_HEM as Dt_Transb 
	From 
		HEM_Transb 
	Where
		Num_Proc_HEM = @Num_Proc 

	Open CurTransb 
	Fetch Next From CurTransb Into @Navio, @Dt_Transb 

	While @@Fetch_Status = 0 
		Begin 
			If @Transbordo = '' or @Transbordo = Null
				Set @Transbordo = 'Nv :' + @Navio + ' - Dt. Transb : ' + dbo.StrHoje(@Dt_Transb ) 
			Else 
				Set @Transbordo = @Transbordo + '// ' + 'Nv :' + @Navio + ' - Dt. Transb : ' + dbo.StrHoje(@Dt_Transb ) 
		
			Fetch Next From CurTransb Into @Navio, @Dt_Transb 			
		End 

	Close CurTransb 
	Deallocate CurTransb 

Select 
	Cliente.Nome_Raz_Soc as Cliente, ComCli.Contato as Cont_Cli, 
	EndCli.Rua as Rua_Cli, EndCli.Numero as Numero_Cli, 
	EndCli.Compl_End as Compl_Cli, EndCli.Bairro as Bairro_Cli,
	EndCli.Cidade as Cidade_Cli, ComCli.Prefixo as Pref_Cli, 
	ComCli.Num_Fone as Fone_Cli,ComCli.Cd_Area_Fone DDD_Cli,

	Dcto.Nome_Raz_Soc as Pessoa_Dcto, ComDcto.Contato as Cont_Dcto, 
	EndDcto.Rua as Rua_Dcto, EndDcto.Numero as Numero_Dcto, 
	EndDcto.Compl_End as Compl_Dcto, EndDcto.Bairro as Bairro_Dcto,
	EndDcto.Cidade as Cidade_Dcto, ComDcto.Prefixo as Pref_Dcto, 
	ComDcto.Num_Fone as Fone_Dcto, ComDcto.Cd_Area_Fone DDD_Dcto,

	Crg.Nome_Raz_Soc as Pessoa_Crg, ComCrg.Contato as Cont_Crg,  
	EndCrg.Rua as Rua_Crg, EndCrg.Numero as Numero_Crg, 
	EndCrg.Compl_End as Compl_Crg, EndCrg.Bairro as Bairro_Crg,
	EndCrg.Cidade as Cidade_Crg, ComCrg.Prefixo as Pref_Crg, 
	ComCrg.Num_Fone as Fone_Crg,ComCrg.Cd_Area_Fone DDD_Crg,
	JEM.*, @StrPO as PO, HEM.Navio_HEM as Navio, HEM.Viagem_HEM as Viagem, 
	Origem.Nome_local as Origem, Destino.Nome_Local as Destino, 
	Importador.Nome_Raz_Soc  as Importador,
	Product.Prod_HEM as Produto, @StrVol as Volume,
	HEM.Peso_Bruto_HEM as Peso_Bruto, HEM.Tp_Frete_HEM as Tp_Frete,
	Usr.Nome_Usuario as Consultor, @Transbordo as Transbordos 
From 
	House_Exp_Mar as HEM Join Job_exp_mar as JEM on JEM.Num_Proc_HEM = HEM.Num_Proc_HEM
	Join Pessoa as Cliente on Cliente.Cd_Pes = HEM.Cd_Export_HEM  
	Left Outer Join Comunicacao as ComCli on (ComCli.Cd_Pes = Cliente.Cd_Pes and ComCli.Cd_Tp_Com = JEM.Cd_Tp_Com_Cli) 
	Left Outer Join Endereco as EndCli on (EndCli.Cd_Pes = HEM.Cd_Export_HEM and EndCli.Cd_Tp_End = 'COM')
	
	Left Outer Join Pessoa as Dcto on Dcto.Cd_Pes = JEM.Cd_Pes_Dcto
	Left Outer Join Comunicacao as ComDcto on (ComDcto.Cd_Pes = Dcto.Cd_Pes and ComDcto.Cd_Tp_Com = JEM.Cd_Tp_Com_Dcto)
	Left Outer Join Endereco as EndDcto on (EndDcto.Cd_Pes = JEM.Cd_Pes_Dcto and EndDcto.Cd_Tp_End = 'COM')

	Left Outer Join Pessoa as Crg on Crg.Cd_Pes = JEM.Cd_Pes_Crg
	Left Outer Join Comunicacao as ComCrg on (ComCrg.Cd_Pes = Crg.Cd_Pes and ComCrg.Cd_Tp_Com = JEM.Cd_Tp_Com_Crg)
	Left Outer Join Endereco as EndCrg on (EndCrg.Cd_Pes = JEM.Cd_Pes_Crg and EndCrg.Cd_Tp_End = 'COM')

	Left Outer Join Localidade as Origem on Origem.Cd_Local = HEM.Cd_Org_HEM 
	Left Outer Join Localidade as Destino on Destino.Cd_Local = HEM.Cd_Dst_HEM 

	Left Outer Join Pessoa as Importador on Importador.Cd_pes = HEM.Cd_Consig_HEM

	Left Outer Join Prd_Hou_Exp_Mar as Product on Product.Num_proc_HEM = HEM.Num_Proc_HEM

	Left Outer Join Usuario as Usr on Usr.Cd_Usuario = JEM.Cd_Usuario 
Where
	HEM.Num_PRoc_HEM = @Num_Proc

GO
