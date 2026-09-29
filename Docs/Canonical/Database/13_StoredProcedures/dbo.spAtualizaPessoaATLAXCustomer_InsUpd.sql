SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spAtualizaPessoaATLAXCustomer_InsUpd]
as



Declare @YourAccountNum	Varchar(12)
Declare @AccountNum		int
Declare @CNPJ				Varchar(20)
Declare @TaxGroup		Varchar(15)
Declare @Tipo			Char(1)
Declare cTemp cursor for
	select OurAccountNum,AccountNum,CNPJCPFNum,TaxGroup,'C' Tipo From dbo.AX_XML_Customer_Recebido Where  dt_envio_atl is null

Open cTemp
	Fetch Next From cTemp into @YourAccountNum,@AccountNum,@CNPJ,@TaxGroup,@Tipo	
	While @@FETCH_STATUS = 0
		Begin
			--Apagar registro Atual
			if @CNPJ is not null 
				Begin
						delete Pessoa_atl_ax where cd_ax=@AccountNum	and tipo='C'		
				End
			Else
				Begin
					delete Pessoa_atl_ax where cd_ax=@AccountNum and cd_pes=@YourAccountNum and tipo='C'	
				
				End			
			--Inserir pessoa_ATL_AX que tenha o cd_pes definido
			insert Pessoa_atl_ax
			select OurAccountNum,AccountNum,CNPJCPFNum,TaxGroup,'C' Tipo From dbo.AX_XML_Customer_Recebido Where  accountnum=@AccountNum and OurAccountNum is not null
			print 'Inserindo por CNPJ'
			print @CNPJ
			print @AccountNum
			print @YourAccountNum
			Insert Pessoa_ATL_AX
			
			select P.cd_pes,@AccountNum,@CNPJ,@TaxGroup,@Tipo	from pessoa P
			left join Pessoa_ATL_AX PA on P.Cd_Pes = PA.Cd_Pes
			where (P.cd_pes <> @YourAccountNum or @YourAccountNum is null) and right(num_cpf_cnpj,14)=replace(replace(replace(@CNPJ,'-',''),'.',''),'/','') and len(num_cpf_cnpj)>1
			
			
			
			update 	AX_XML_Customer_Recebido set dt_envio_ATL=getdate() where 	AccountNum=@AccountNum
			Fetch Next From cTemp into @YourAccountNum,@AccountNum,@CNPJ,@TaxGroup,@Tipo			
		End
		
GO
