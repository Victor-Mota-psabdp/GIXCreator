SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spRegistro_Financeiro_MesAno_Sel]--'M'

	@ano char(1)

As
	if @ano = 'M'
		Begin
			Select '00 - This Month' Mes 
			
			union All
			
			select distinct		
				right('0' + convert(varchar,mes),2) + ' - ' + datename(mm,DateAdd(month,mes,0)-1) Mes
			from 
				registro_financeiro
			where
				mes <> month(Getdate())
			order by 1
		end
	else
		Begin
			Select 'This Year' Ano			 
			
			union All

			select distinct		
				convert(varchar,ano)
			from 
				registro_financeiro 
			where
				ano <> year(Getdate())
			order by 1

		End


GO
