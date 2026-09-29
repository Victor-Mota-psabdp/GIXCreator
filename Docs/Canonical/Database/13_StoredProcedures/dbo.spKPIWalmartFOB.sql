SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PRocedure [dbo].[spKPIWalmartFOB]


as

Declare @mes int
Declare @ano int
Declare @UltimaData Datetime
Declare @IntI as int
Declare @Saida as Table
		(
			Mes			varchar(3),		
				FOb			float,
					Dias		int,
			Evento		Varchar(40),
			Ano			int
		)

		

Set @IntI = 1


set @UltimaData='01-01-2009'

Set @mes=month(@UltimaData)
Set @Ano = year(@UltimaData)


While @IntI<=12
	BEGIN
		
		if @mes=12 
			Begin
				Set @mes=1
				Set @ano=@ano+1
			end
		else
			Begin
					SET @MES=@MES+1
			END
		
		SET @ULTIMADATA=cast(@ano as varchar(4)) + '-' + cast(@mes as varchar(2)) + '-01'
		print(cast(@ano as varchar(4)) + '-' + cast(@mes as varchar(2)) + '-01')

		Insert into @Saida

		select LEFT(DATENAME(MONTH,(@ULTIMADATA)),3) Mes,dbo.FBusca_FOB(num_proc_lim,'W') FOB, cast(@UltimaData-ata_lim as int) Dias,dbo.fBusca_CampoCliente(num_proc_lim,19) Evento,@ano from llp_imp_mar
		Join Tarefas_Processos TP on TP.num_proc=num_proc_lim and id_task=4
		Where
			(dt_conclusao > @UltimaData or dt_conclusao is null)
			and Ata_LIM <=@ultimadata
			and num_proc_lim like 'IMWAL%'

		set @INTI=@INTI+1


	END
		select * from @saida

GO
