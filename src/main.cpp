/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.cpp                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: amassias <amassias@student.42lehavre.fr    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/05/28 01:58:48 by amassias          #+#    #+#             */
/*   Updated: 2024/06/06 10:04:05 by amassias         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "Server.hpp"
#include "Log.hpp"

#include <cstdlib>
#include <cstring>

static void	usage(char *pn)
{
	std::cerr << "usage: " << pn << " [PORT] [PASSWORD]" << std::endl;
}

enum ProgramArgs
{
	PROG_PN,
	PROG_PORT,
	PROG_PWD,
	PROG__NBARGS,
};

int	main(int argc, char **argv)
{
	if (argc != 3)
	{
		std::cerr << argv[PROG_PN] << ": Invalid number of arguments." << std::endl;
		usage(argv[PROG_PN]);
		return (EXIT_FAILURE);
	}
	for (char *str = argv[PROG_PORT]; *str != '\0'; ++str)
		if (!std::isdigit(*str))
		{
			std::cerr << argv[PROG_PN] << ": Invalid port number." << std::endl;
			usage(argv[PROG_PN]);
			return (EXIT_FAILURE);
		}
	const int	port = atoi(argv[PROG_PORT]);
	try
	{
		Server::getInstance()->setPwd(argv[PROG_PWD]);
		Server::getInstance()->setPort(port);
		Server::getInstance()->init();
		Server::getInstance()->loop();
		Server::destroyInstance();
	} catch (const std::exception &e)
	{
		Log::Error << "Server encountered a fatal error : " << e.what() << std::endl;
	}
	return (0);
}
