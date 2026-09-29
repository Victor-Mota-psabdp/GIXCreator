SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--spAtualizaVolumeAnual_Rel 'C', 'C', 'C','C'
--17/12/2012 - alterado pra trazer o pais de origem e destino - ARG
CREATE procedure [dbo].[spAtualizaVolumeAnual_Rel] --'D','S', '%', '%IM%'

	@Tipo	char(1),
	@Filtro	char(1),
	@Grupo	Varchar(50),
	@Modal	varchar(4)
	
as
	
SET NOCOUNT ON;
	--Tabla temporaria que vai receber os dados da stored
	Declare @TempTableDados table
				(
				Cliente varchar(50),
				Mes		int,
				Ano		int,
				Tipo	Varchar(40),
				Job		Varchar(16),
				Modal	varchar(2),
				Origem	varchar(30),				
				Pais_Origem varchar(30),
				Destino	varchar(30),
				Pais_Destino varchar(30)
				)
	--Tabela para Definir o periodo de meses os 10 proximos mais o atual e um anterior		
	declare @Colunas table
			(
			IDMes  int,
			MesAno datetime
			)

	Declare @DataInicial	varchar (10)
	Declare @DataFinal		varchar (10)
	Declare @DtMes			int
	Declare @Ano			int
	Declare @IntI			INT
	Declare @DataTemp		Datetime

--	set @DtMes = (datepart(mm,getdate())-12) * -1
--			if @DtMes = 0
--				begin
--					set @DtMes = 1
--				end
--			if month(getdate()) <= 10
--				begin
--					set @Ano = (year(getdate())-1)
--				end
--		set @DataInicial = cast(@Ano as varchar(4)) +'-' + right('0' + cast(@DtMes as varchar(4)),2)  +  '-01'

		set @DataTemp = (select dateadd(month,-11,getdate()))

		Set @DataInicial=cast(year(@DataTemp) as varchar(4)) + '-' + right('0' + cast(month(@DataTemp) as varchar(2)),2)  +  '-01'

		set @DtMes = datepart(mm,getdate())+1
			if @DtMes > 12
				begin
					set @DtMes = 1
					set @Ano = year(getdate()) +1
				end
			else
				begin
					set @Ano = year(getdate())
				end
		set @DataFinal = cast(@Ano as varchar(4)) +'-' + right('0' + cast(@DtMes as varchar(4)),2)  +  '-01'
		
		set @IntI=1

		Insert @Colunas values(1,@datainicial)

		While @IntI <=11
			Begin
				set @inti=@inti+1
				Set @DataTemp=(select max(mesano) from @Colunas) + 31
				Set @DtMes=month(@dataTemp)
				SEt @Ano=year(@DataTemp)
				Set @DataTemp=cast(@ano as varchar(4)) +'-' + right('0' + cast(@DtMes as varchar(2)),2)  +  '-01'
				Insert @Colunas values(@inti,@DataTemp)	
			End

	insert @TempTableDados
	exec dbo.spEmbarquesATL_LLP_REL @DataInicial,@DataFinal 

SET NOCOUNT OFF;

	if @Tipo = 'C'
		begin
			Select  cast(month(MesAno) as Varchar(2)) + '/' + cast(year(mesano) as varchar(4)) Colunas  from @Colunas
		end
	else
		if @Filtro = 'G'
			begin
				select TD.Cliente,TD.Tipo,TD.Modal,TD.Origem,TD.Pais_Origem,TD.Destino,TD.Pais_Destino,
						count(C1.idmes) C1,count(C2.idmes) C2,count(C3.idmes) C3,count(C4.idmes) C4,count(C5.idmes) C5,
						count(C6.idmes) C6,count(C7.idmes) C7, count(C8.idmes) C8, count(C9.idmes) C9,count(C10.idmes) C10,count(C11.idmes) C11,count(C12.idmes) C12
				from @TempTableDados TD
					left join @Colunas C1 on C1.IDMes = 1 and year(C1.mesano) = TD.Ano and month(C1.mesano)=TD.Mes
					left join @Colunas C2 on C2.IDMes = 2 and year(C2.mesano) = TD.Ano and month(C2.mesano)=TD.Mes
					left join @Colunas C3 on C3.IDMes = 3 and year(C3.mesano) = TD.Ano and month(C3.mesano)=TD.Mes 
					left join @Colunas C4 on C4.IDMes = 4 and year(C4.mesano) = TD.Ano and month(C4.mesano)=TD.Mes 
					left join @Colunas C5 on C5.IDMes = 5 and year(C5.mesano) = TD.Ano and month(C5.mesano)=TD.Mes 
					left join @Colunas C6 on C6.IDMes = 6 and year(C6.mesano) = TD.Ano and month(C6.mesano)=TD.Mes 
					left join @Colunas C7 on C7.IDMes = 7 and year(C7.mesano) = TD.Ano and month(C7.mesano)=TD.Mes 
					left join @Colunas C8 on C8.IDMes = 8 and year(C8.mesano) = TD.Ano and month(C8.mesano)=TD.Mes 
					left join @Colunas C9 on C9.IDMes = 9 and year(C9.mesano) = TD.Ano and month(C9.mesano)=TD.Mes 
					left join @Colunas C10 on C10.IDMes = 10 and year(C10.mesano) = TD.Ano and month(C10.mesano)=TD.Mes 
					left join @Colunas C11 on C11.IDMes = 11 and year(C11.mesano) = TD.Ano and month(C11.mesano)=TD.Mes 
					left join @Colunas C12 on C12.IDMes = 12 and year(C12.mesano) = TD.Ano and month(C12.mesano)=TD.Mes 
				where
					Cliente like @Grupo and Modal like @Modal
				group by
					TD.Cliente, TD.Tipo,TD.Modal, TD.Origem,TD.Pais_Origem,TD.Destino,TD.Pais_Destino
			
				Union all

				select 'TOTAL' ,Null,Null ,Null ,Null,Null,Null,
						count(C1.idmes) C1,count(C2.idmes) C2,count(C3.idmes) C3,count(C4.idmes) C4,count(C5.idmes) C5,
						count(C6.idmes) C6,count(C7.idmes) C7, count(C8.idmes) C8, count(C9.idmes) C9,count(C10.idmes) C10,count(C11.idmes) C11,count(C12.idmes) C12
				from @TempTableDados TD
					left join @Colunas C1 on C1.IDMes = 1 and year(C1.mesano) = TD.Ano and month(C1.mesano)=TD.Mes
					left join @Colunas C2 on C2.IDMes = 2 and year(C2.mesano) = TD.Ano and month(C2.mesano)=TD.Mes
					left join @Colunas C3 on C3.IDMes = 3 and year(C3.mesano) = TD.Ano and month(C3.mesano)=TD.Mes 
					left join @Colunas C4 on C4.IDMes = 4 and year(C4.mesano) = TD.Ano and month(C4.mesano)=TD.Mes 
					left join @Colunas C5 on C5.IDMes = 5 and year(C5.mesano) = TD.Ano and month(C5.mesano)=TD.Mes 
					left join @Colunas C6 on C6.IDMes = 6 and year(C6.mesano) = TD.Ano and month(C6.mesano)=TD.Mes 
					left join @Colunas C7 on C7.IDMes = 7 and year(C7.mesano) = TD.Ano and month(C7.mesano)=TD.Mes 
					left join @Colunas C8 on C8.IDMes = 8 and year(C8.mesano) = TD.Ano and month(C8.mesano)=TD.Mes 
					left join @Colunas C9 on C9.IDMes = 9 and year(C9.mesano) = TD.Ano and month(C9.mesano)=TD.Mes 
					left join @Colunas C10 on C10.IDMes = 10 and year(C10.mesano) = TD.Ano and month(C10.mesano)=TD.Mes 
					left join @Colunas C11 on C11.IDMes = 11 and year(C11.mesano) = TD.Ano and month(C11.mesano)=TD.Mes 
					left join @Colunas C12 on C12.IDMes = 12 and year(C12.mesano) = TD.Ano and month(C12.mesano)=TD.Mes 
				where
					Cliente like @Grupo and Modal like @Modal

			end
		else
			begin
				select TD.Cliente,TD.Modal,
					count(C1.idmes) C1,count(C2.idmes) C2,count(C3.idmes) C3,count(C4.idmes) C4,count(C5.idmes) C5,
					count(C6.idmes) C6,count(C7.idmes) C7, count(C8.idmes) C8, count(C9.idmes) C9,count(C10.idmes) C10,count(C11.idmes) C11,count(C12.idmes) C12
				from @TempTableDados TD
					left join @Colunas C1 on C1.IDMes = 1 and year(C1.mesano) = TD.Ano and month(C1.mesano)=TD.Mes
					left join @Colunas C2 on C2.IDMes = 2 and year(C2.mesano) = TD.Ano and month(C2.mesano)=TD.Mes
					left join @Colunas C3 on C3.IDMes = 3 and year(C3.mesano) = TD.Ano and month(C3.mesano)=TD.Mes 
					left join @Colunas C4 on C4.IDMes = 4 and year(C4.mesano) = TD.Ano and month(C4.mesano)=TD.Mes 
					left join @Colunas C5 on C5.IDMes = 5 and year(C5.mesano) = TD.Ano and month(C5.mesano)=TD.Mes 
					left join @Colunas C6 on C6.IDMes = 6 and year(C6.mesano) = TD.Ano and month(C6.mesano)=TD.Mes 
					left join @Colunas C7 on C7.IDMes = 7 and year(C7.mesano) = TD.Ano and month(C7.mesano)=TD.Mes 
					left join @Colunas C8 on C8.IDMes = 8 and year(C8.mesano) = TD.Ano and month(C8.mesano)=TD.Mes 
					left join @Colunas C9 on C9.IDMes = 9 and year(C9.mesano) = TD.Ano and month(C9.mesano)=TD.Mes 
					left join @Colunas C10 on C10.IDMes = 10 and year(C10.mesano) = TD.Ano and month(C10.mesano)=TD.Mes 
					left join @Colunas C11 on C11.IDMes = 11 and year(C11.mesano) = TD.Ano and month(C11.mesano)=TD.Mes 
					left join @Colunas C12 on C12.IDMes = 12 and year(C12.mesano) = TD.Ano and month(C12.mesano)=TD.Mes 
				where
					Cliente like @Grupo and Modal like @Modal
				group by
					TD.Cliente, TD.Modal
			
				Union all

				select 'TOTAL' ,Null,
						count(C1.idmes) C1,count(C2.idmes) C2,count(C3.idmes) C3,count(C4.idmes) C4,count(C5.idmes) C5,
						count(C6.idmes) C6,count(C7.idmes) C7, count(C8.idmes) C8, count(C9.idmes) C9,count(C10.idmes) C10,count(C11.idmes) C11,count(C12.idmes) C12
				from @TempTableDados TD
					left join @Colunas C1 on C1.IDMes = 1 and year(C1.mesano) = TD.Ano and month(C1.mesano)=TD.Mes
					left join @Colunas C2 on C2.IDMes = 2 and year(C2.mesano) = TD.Ano and month(C2.mesano)=TD.Mes
					left join @Colunas C3 on C3.IDMes = 3 and year(C3.mesano) = TD.Ano and month(C3.mesano)=TD.Mes 
					left join @Colunas C4 on C4.IDMes = 4 and year(C4.mesano) = TD.Ano and month(C4.mesano)=TD.Mes 
					left join @Colunas C5 on C5.IDMes = 5 and year(C5.mesano) = TD.Ano and month(C5.mesano)=TD.Mes 
					left join @Colunas C6 on C6.IDMes = 6 and year(C6.mesano) = TD.Ano and month(C6.mesano)=TD.Mes 
					left join @Colunas C7 on C7.IDMes = 7 and year(C7.mesano) = TD.Ano and month(C7.mesano)=TD.Mes 
					left join @Colunas C8 on C8.IDMes = 8 and year(C8.mesano) = TD.Ano and month(C8.mesano)=TD.Mes 
					left join @Colunas C9 on C9.IDMes = 9 and year(C9.mesano) = TD.Ano and month(C9.mesano)=TD.Mes 
					left join @Colunas C10 on C10.IDMes = 10 and year(C10.mesano) = TD.Ano and month(C10.mesano)=TD.Mes 
					left join @Colunas C11 on C11.IDMes = 11 and year(C11.mesano) = TD.Ano and month(C11.mesano)=TD.Mes 
					left join @Colunas C12 on C12.IDMes = 12 and year(C12.mesano) = TD.Ano and month(C12.mesano)=TD.Mes 
				where
					Cliente like @Grupo and Modal like @Modal
			end
GO
