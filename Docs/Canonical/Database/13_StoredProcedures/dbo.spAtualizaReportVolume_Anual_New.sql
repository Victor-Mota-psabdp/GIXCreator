SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spAtualizaReportVolume_Anual_New]

AS

Declare @Cliente	Varchar(50)
Declare @Modal		Varchar(50)
Declare @mes		int
Declare @Ano		int
Declare @Emb		int
Declare @Localidade Varchar(40)


Declare @tempTable Table
		(
			Localidade Varchar(40),
			Cliente Varchar(50),
			Mes		Int,			
			Ano		int,
			Tipo	Varchar(40),
			Emb		int,
			Modal	Varchar(15)

		)
		
insert @temptable
--Exec dbo.spEmbarquesLLP_REL '01-01-2012','12-31-2012'
--Exec dbo.spEmbarquesLLP_REL '01-01-2013','12-31-2013'
--Exec dbo.spEmbarquesLLP_REL '2014-01-01','2014-12-31' 

Exec [dbo].[spEmbarquesLLP_NEW_REL] '01-01-2008','12-31-2014'

delete temp_ReportVolume_Anual_New
 
insert temp_ReportVolume_Anual_New (localidade,nome_cliente,modal,Ano)
select distinct localidade,cliente,modal,Ano from @temptable

Declare ctemp Cursor for
	Select Localidade,Cliente,Modal,Mes,Ano,sum(emb) Qty From @temptable
	Group by Cliente, Modal,Mes,Ano,Localidade
	open cTemp	
	fetch next from cTemp into @Localidade,@Cliente, @Modal,@Mes,@Ano,@Emb

	While @@fetch_status=0
		Begin
			if @Mes=1
				Begin
					Update temp_ReportVolume_Anual_New
							Set Janeiro=Janeiro+@emb
						Where Nome_Cliente=@Cliente and Modal=@Modal and Localidade=@Localidade and Ano = @Ano
				END
			if @Mes=2
				Begin
					Update temp_ReportVolume_Anual_New
							Set Fevereiro=Fevereiro+@emb
						Where Nome_Cliente=@Cliente and Modal=@Modal and Localidade=@Localidade and Ano = @Ano
				END
			if @Mes=3
				Begin
					Update temp_ReportVolume_Anual_New
							Set Marco=Marco+@emb
						Where Nome_Cliente=@Cliente and Modal=@Modal and Localidade=@Localidade and Ano = @Ano
				END
			if @Mes=4
				Begin
					Update temp_ReportVolume_Anual_New
							Set Abril=Abril+@emb
						Where Nome_Cliente=@Cliente and Modal=@Modal and Localidade=@Localidade and Ano = @Ano
				END
			if @Mes=5
				Begin
					Update temp_ReportVolume_Anual_New
							Set Maio=Maio+@emb
						Where Nome_Cliente=@Cliente and Modal=@Modal and Localidade=@Localidade and Ano = @Ano
				END
			if @Mes=6
				Begin
					Update temp_ReportVolume_Anual_New
							Set Junho=Junho+@emb
						Where Nome_Cliente=@Cliente and Modal=@Modal and Localidade=@Localidade and Ano = @Ano
				END
			if @Mes=7
				Begin
					Update temp_ReportVolume_Anual_New
							Set Julho=Julho+@emb
						Where Nome_Cliente=@Cliente and Modal=@Modal and Localidade=@Localidade and Ano = @Ano
				END
			if @Mes=8
				Begin
					Update temp_ReportVolume_Anual_New
							Set Agosto=Agosto+@emb
						Where Nome_Cliente=@Cliente and Modal=@Modal and Localidade=@Localidade and Ano = @Ano
				END
			if @Mes=9
				Begin
					Update temp_ReportVolume_Anual_New
							Set Setembro=Setembro+@emb
						Where Nome_Cliente=@Cliente and Modal=@Modal and Localidade=@Localidade and Ano = @Ano
				END
			if @Mes=10
				Begin
					Update temp_ReportVolume_Anual_New
							Set Outubro=Outubro+@emb
						Where Nome_Cliente=@Cliente and Modal=@Modal and Localidade=@Localidade and Ano = @Ano
				END
			if @Mes=11
				Begin
					Update temp_ReportVolume_Anual_New
							Set Novembro=Novembro+@emb
						Where Nome_Cliente=@Cliente and Modal=@Modal and Localidade=@Localidade and Ano = @Ano
				END
			if @Mes=12
				Begin
					Update temp_ReportVolume_Anual_New
							Set Dezembro=Dezembro+@emb
						Where Nome_Cliente=@Cliente and Modal=@Modal and Localidade=@Localidade and Ano = @Ano
				END

			fetch next from cTemp into @Localidade,@Cliente, @Modal,@Mes,@Ano,@Emb
		End
	
	close ctemp
	Deallocate cTemp










GO
