/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   Client.hpp                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: amassias <amassias@student.42lehavre.fr    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/05/28 01:58:54 by amassias          #+#    #+#             */
/*   Updated: 2024/05/28 01:58:55 by amassias         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef CLIENT_H
# define CLIENT_H

# include <string>

# include "utils.hpp"

class Client
{
	public:
		Client();
		~Client();

		std::string	getNickname() const;
		std::string	getUsername() const;
		std::string	getRealname() const;

		void		setNickname(std::string const& s);
		void		setUsername(std::string const& s);
		void		setRealname(std::string const& s);

		void		receive(int fd);

	private:
		std::string	m_nickname;
		std::string	m_username;
		std::string	m_realname;
		bool		m_logged;

	public:
		
		CREATE_EXCEPTION(ConnexionLost, "Connexion lost");
		CREATE_EXCEPTION(ReadError, "Read error");
};

#endif

